
require 'xtmfile/header'

module XtmFile
	class Splitter
		attr_reader :parts_size
		def initialize input_filename
			@input_filename = input_filename

			# create and initialize header
			@header = Header.new
			@header.filename_str = @input_filename
		end

		def parts= count
			@header.filecount = count
			@parts_size = @header.filesize / count
		end

		def parts_size= size
			count = @header.filesize / size
			remain = @header.filesize % size
			count += 1 if remain > 0
			@header.filecount = count
		end

		def start
		end
	end
end
