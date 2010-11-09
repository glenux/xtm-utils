
class XtmHeader < BinData::Record
	# Offset  	Information  	Taille (octets)
	# 0 	Longueur du nom du programme 	1
	# 1 	*Nom du programme 	20
	# 21 	Longueur de la version 	1
	# 22 	Version 	4
	# 26 	Not used 	10
	# 36 	Date 	4
	# 40 	Longueur du nom du fichier original 	1
	# 41 	Nom du fichier original 	50
	# 91 	**Hash MD5 	1
	# 92 	Nombre de fichiers 	4
	# 96 	Taille du fichier original 	8

	endian :little

	uint8 :progname_len, :value => lambda { progname_str.length }
	string :progname_str, :length => 20

	uint8 :version_len, :value => lambda { version_str.length }
	string :version_str, :length => 4

	string :unused, :length => 10

	uint32le :date

	uint8 :filename_len
	string :filename_str, :read_length => :filename_len
	string :filename_str_pad, :read_length => lambda { 50 - filename_len }

	uint8 :md5

	uint32 :filecount
	uint64 :filesize

	def to_s
		r = []
		r << ( "Progname len : %s [%s]" % [self.progname_len, self.progname_len.offset] )
		r << ( "Progname str : %s [%s]" % [self.progname_str, self.progname_str.offset] )
		r << ( " Version len : %s [%s]" % [self.version_len, self.version_len.offset] )
		r << ( " Version str : %s [%s]" % [self.version_str, self.version_str.offset] )
		r << ( "      Unused : %s [%s]" % [self.unused, self.unused.offset] )
		r << ( "        Date : %s [%s]" % [self.date, self.date.offset] )
		r << ( "Filename len : %s [%s]" % [self.filename_len, self.filename_len.offset] )
		r << ( "Filename str : %s [%s]" % [self.filename_str, self.filename_str.offset] )
		r << ( "         md5 : %s [%s]" % [self.md5, self.md5.offset] )
		r << ( "   Filecount : %d [%s]" % [self.filecount, self.filecount.offset] )
		r << ( "    Filesize : %s [%s]" % [self.filesize, self.filesize.offset] )
		return r.join("\n")
	end
end
