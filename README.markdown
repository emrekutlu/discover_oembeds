
Discover Oembeds
================

Discover Oembeds parses your model, finds the the links, gets the data from the provider and saves that data to the database. Supports three providers: [Flickr](http://www.flickr.com), [Vimeo](http://www.vimeo.com), [YouTube](http://www.youtube.com).

Installation
============

	script/plugin install git://github.com/emrekutlu/discover_oembeds.git

Requires [HTTparty](http://github.com/jnunemaker/httparty).

	sudo gem install httparty

Create a migration.

	script/generate migration create_oembeds

Copy this migration.

	class CreateOembeds < ActiveRecord::Migration

		def self.up
			create_table :oembeds do |t|
				t.string			:kind
				t.string			:version
				t.string			:title
				t.string			:author_name
				t.string			:author_url
				t.string			:provider_name
				t.string			:provider_url
				t.integer			:cache_age
				t.string			:thumbnail_url
				t.string			:thumbnail_width
				t.string			:thumbnail_height
				t.string			:url
				t.text				:html
				t.integer			:width
				t.integer			:height
				t.string			:field
				t.string			:href
				t.references	:resource, :polymorphic => true
				t.timestamps
			end

			add_index :oembeds, :resource_type
			add_index :oembeds, :resource_id
		end

		def self.down
			drop_table :oembeds
		end

	end

Usage
=====

Just add <code>discover_oembeds</code> method to your model.

	class Post < ActiveRecord::Base
		discover_oembeds :body
	end

This code will check the <code>body</code> attribute of the <code>Post</code> model for available oembeds.

Getting the oembeds of a <code>Post</code> model:

	Post.last.oembeds

Examples
--------

	discover_oembeds #if no parameter given, checks the :content attribute
	discover_oembeds :body #checks the :body attribute
	discover_oembeds :body, :title #checks multiple attributes, to get just :body attributes' oembeds Post.last.oembeds.body
	discover_oembeds :body => { :providers => :flickr }	#checks just flickr, other options :youtube and :vimeo
	discover_oembeds [{ :body => { :providers => :flickr } }, :title] #multiple attributes with :providers option

Providers
=========

Providers must extend <code>DiscoverOembeds::Providers::Base</code>.

	module DiscoverOembeds
		module Providers

			class Vimeo < Base

				ENDPOINT			= 'http://www.vimeo.com/api/oembed.{format}'
				SCHEMES				= [Regexp.new('(http:\/\/((www\.)?)vimeo\.com\/\d+)'), Regexp.new('(http:\/\/((www\.)?)vimeo\.com\/groups\/\S+\/videos\/\d+)')]
				FORMAT				= 'json'
				PARAMS				= { :maxwidth => 450 }
				THUMB_PARAMS	= { :maxheight => 75 }

			end

		end
	end

There is an addition to oembed protocol which is <code>THUMB_PARAMS</code> to get a thumbnail which has different dimensions. It costs extra one request.

TODO
====

* Implement an easy way to set the <code>PARAMS</code>

---
For more information about the protocol [oembed.com](http://www.oembed.com)

Copyright (c) 2010 [İ. Emre Kutlu](http://www.emrekutlu.com), released under the MIT license