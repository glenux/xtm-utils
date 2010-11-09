#!/usr/bin/ruby -d

require 'rake'

spec = Gem::Specification.new do |s|
	s.author = 'Glenn Y. Rolland'
	s.email = 'glenux@glenux.net'
	s.homepage = 'http://glenux.github.com/xtm-utils/'

	s.signing_key = ENV['GEM_PRIVATE_KEY']
	s.cert_chain  = ENV['GEM_CERTIFICATE_CHAIN']

	s.name = 'xtm-utils'
	s.version = '0.1'
	s.summary = 'A set of tools for joining or splitting files using the XTM format.'
	s.description = ' xtm-utils is a set of tools for joining or splitting files using the XTM format .' \
		'It is an open-source replacement for the the closed-source binary provided by the XtremSplit website.'

	s.required_ruby_version = '>= 1.8.5'

	s.require_paths = ['xtmfile']
	s.files = FileList[
		"xtmfile/*.rb", 
		"bin/*", 
	].to_a + [
		"Makefile",
		"xtm-utils.gemspec",
		"COPYING",
		"README.rdoc"
	]
	s.files.reject! { |fn| fn.include? "coverage" }

	puts "== GEM CONTENT =="
	puts s.files
	puts "== /GEM CONTENT =="
end
