#!/usr/bin/ruby
require 'pathname'

def cleanupLine line
  line.gsub! "[",""
  line.gsub! "]",""
  line.gsub! "\"",""
  line.gsub! ", ",","
  return line
end

currentDirectory=File.dirname(__FILE__)
inDir=File.join(currentDirectory, "raw")
outDir=File.join(currentDirectory, "index")

puts "Scanning files in the directory: \"#{inDir}\""
filesString=`find "#{inDir}" -name "*" -type f`
files=filesString.split("\n")


output=Hash.new
filePaths=[]

files.each do |filePath|
  #removing the files that don't end with "." character
  fileName=Pathname.new(filePath).basename.to_s  
  next if fileName[fileName.length-1,1] != '.'
  
  
  filePaths << filePath
  File.open(filePath, "r") do |f|
    lineCounter=0;
    f.each_line do |line|
      line.downcase!
      #additional analysis needed to remove garbage from the email headers and metadata
      line.gsub!(/[^a-z\s(0-9)\-]/, '')
      words=line.split
      words.each do |w| 
        output[w]=[] if output[w]==nil
        output[w]<<[filePaths.length-1, lineCounter];
      end
      
      lineCounter=lineCounter+1;
    end    
  end

    

end




#writing out files map
File.open(File.join(outDir,"paths.txt"), "w") do |f|
  filePaths.each {|filePath| f.puts filePath.gsub currentDirectory, ""}
end

#writing out the sorted file

#sorting the output data
sortedOutput=[]
output.each {|word, placement| sortedOutput << [word, placement].flatten}

sortedOutput.sort! { |x, y| x[0] <=> y[0] }

letterIndex =[]

File.open(File.join(outDir,"data.txt"), "w") do |f|
  charNumber=0
  prevLetters=""  
  sortedOutput.each do |outArray|
    currentLetter=outArray[0][0,3]
    if currentLetter!=prevLetters
      letterIndex << [currentLetter, charNumber]
      prevLetters=currentLetter
    end
    outString=cleanupLine outArray.inspect
    f.puts outString
    charNumber=charNumber+outString.length+1 # 1 for new line char
   end
end

#writing out the letter indexes
File.open(File.join(outDir,"index.txt"), "w") do |f|
  letterIndex.each {|li| f.puts cleanupLine li.inspect}
end