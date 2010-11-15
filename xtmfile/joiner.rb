
require 'xtmfile/header'

module XtmFile

	class Joiner

		attr_reader :header, :input_filename, :output_filename

		# yield this event + filename when opening a new file
		EVENT_OPENFILE = :file
		# yield this event + percent on joining progress
		EVENT_PROGRESS = :progress

		BUFFER_MAX_SIZE = 4096 * 4096

		def initialize input, output=nil
			@input_filename = input
			@output_filename = output

			File.open @input_filename, "rb" do |in_xtm|
				@header = Header::read in_xtm
			end
			if @output_filename.nil? then
				@output_filename = @header.filename_str
			end
		end

		def start &blk
			in_xtm = File.open @input_filename, "rb"
			in_xtm.seek @header.num_bytes, IO::SEEK_SET

			yield EVENT_OPENFILE, @input_filename if block_given?


			out_xtm = File.open @output_filename, "wb"

			cur_xtm = @input_filename
			is_first = true
			cur_size = @header.filesize
			print "\x1b[s"
			while cur_size > 0 do
				unless is_first then
					cur_xtm = _nextfile cur_xtm
					yield EVENT_OPENFILE, cur_xtm if block_given?
					in_xtm = File.open cur_xtm, "rb"
				end
				while cur_size > 0 and (not in_xtm.eof?) do
					pcent = (( @header.filesize - cur_size) * 100 / @header.filesize)
					yield EVENT_PROGRESS, pcent if block_given?

					read_size = if  cur_size > BUFFER_MAX_SIZE then BUFFER_MAX_SIZE
								else cur_size
								end
					buffer = in_xtm.read read_size
					cur_size = cur_size - buffer.length
					out_xtm.write buffer.slice(0, buffer.length)
				end
				is_first = false
				in_xtm.close
			end
			out_xtm.close

			# remaining files
		end

		def _nextfile curfile
			result = nil
			cur_idx = 0
			cur_len = 0
			case curfile
			when /\.([0-9]+)\.xtm$/ then
				cur_idx = $1.to_i
				cur_len = $1.length
				next_idx = cur_idx + 1
				result = curfile.gsub(/\.([0-9]+)\.xtm$/, ".%0#{cur_len}d.xtm" % next_idx)
			when /\.xtm\.([0-9]+)$/ then
				cur_idx = $1.to_i
				cur_len = $1.length
				next_idx = cur_idx + 1
				result = curfile.gsub(/\.xtm\.([0-9]+)$/, ".xtm.%0#{cur_len}d" % next_idx)
			else
				raise "Unable to detect a naming patterng for file sequence!"
			end
			return result
		end
	end
end

