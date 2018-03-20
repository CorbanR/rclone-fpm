require 'digest'
require 'zip'

def download_file(url, checksum)
  download = open(url)
  filename = url.to_s.split('/')[-1]
  filepath = "#{@root_dir}/tmp_files/#{filename}"

  unless File.file?(filepath)
    puts "Downloading #{filepath}"
    IO.copy_stream(download, filepath)
  else
    puts "#{filepath} already exists.. continuing"
  end

  if File.file?(filepath)
    sha256 = Digest::SHA256.file filepath
    unless sha256 == checksum
      puts "Checksum mismatch... got #{sha256} but expected #{checksum}"
      exit 1
    else
      Zip.setup do |c|
        c.on_exists_proc = true
        c.write_zip64_support = true
      end
      Zip::File.open(filepath) do |zip_file|
        zip_file.each do |entry|
          puts "Extracting #{entry.name}"
          entry.extract("#{@root_dir}/tmp_files/#{entry}")
        end
      end
    end
  end

end
