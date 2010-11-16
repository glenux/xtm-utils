
require 'rubygems'
gem 'bindata', '~> 1.2.1'
require 'bindata'

# FIXME: set default values for header fields
module XtmFile

	#
	#  Offset | Information          | Size (bytes)
	#  --------------------------------------------
	#     0   | Software name length |    1
	#     1   | Software name        |   20
	#    21   | Version length       |    1
	#    22   | Version              |    4
	#    26   | Not used             |   10
	#    36   | Date                 |    4
	#    40   | Filename length      |    1
	#    41   | Filename             |   50
	#    91   | MD5 Enable           |    1
	#    92   | File parts count     |    4
	#    96   | Original file size   |    8
	#
	class Header < BinData::Record
		endian :little

		uint8 :progname_len, :value => lambda { progname_str.length }
		string :progname_str, :length => 20

		uint8 :version_len, :value => lambda { version_str.length }
		string :version_str, :length => 4

		string :unused, :length => 10

		uint32le :date

		uint8 :filename_len
		string :filename_str, :read_length => :filename_len
		# fake padding
		string :filename_str_pad, :read_length => lambda { 50 - filename_len }

		uint8 :md5

		uint32 :filecount
		uint64 :filesize

		def to_full_string
			r = []
			r << "[%03d] Progname len : %s" % [self.progname_len.offset, self.progname_len]
			r << "[%03d] Progname str : %s" % [self.progname_str.offset, self.progname_str]
			r << "[%03d]  Version len : %s" % [self.version_len.offset, self.version_len]
			r << "[%03d]  Version str : %s" % [self.version_str.offset, self.version_str]
			r << "[%03d]       Unused : %s" % [self.unused.offset, self.unused]
			r << "[%03d]         Date : %s" % [self.date.offset, self.date]
			r << "[%03d] Filename len : %s" % [self.filename_len.offset, self.filename_len]
			r << "[%03d] Filename str : %s" % [self.filename_str.offset, self.filename_str]
			r << "[%03d]          md5 : %s" % [self.md5.offset, self.md5]
			r << "[%03d]    Filecount : %d" % [self.filecount.offset, self.filecount]
			r << "[%03d]     Filesize : %s" % [self.filesize.offset, self.filesize]
			return r.join("\n")
		end


		def to_summary_string
			r = []
			r << "    Software : %s (%s)" % [self.progname_str,self.version_str]
			r << "        Date : %s" % self.date
			r << "Filename str : %s" % self.filename_str
			r << "         md5 : %s" % ( self.md5 ? 'enabled' : 'disabled' )
			r << "   Filecount : %d" % self.filecount
			r << "    Filesize : %s" % _readable_file_size( self.filesize, 2 )
			return r.join("\n")
		end

		private

		GIGA_SIZE = 1073741824.0
		MEGA_SIZE = 1048576.0
		KILO_SIZE = 1024.0
		def _readable_file_size size, precision

			case
			when size == 1 : "1 Byte"
			when size < KILO_SIZE : "%d Bytes" % size
			when size < MEGA_SIZE : "%.#{precision}f KB" % (size / KILO_SIZE)
			when size < GIGA_SIZE : "%.#{precision}f MB" % (size / MEGA_SIZE)
			else "%.#{precision}f GB" % (size / GIGA_SIZE)
			end
		end

	end
end
