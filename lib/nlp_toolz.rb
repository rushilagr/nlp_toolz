# coding:  utf-8
# author: LeFnord
# email:  pscholz.le@gmail.com
# date:   2012-10-23

# for java usage
require "rjb"

# external requirements
require "awesome_print"
require "multi_json"
# for downloading models and jars
require "zip/zip"

# internal requirements
require "nlp_toolz/version"
require "nlp_toolz/helpers/url_handler"
require "nlp_toolz/helpers/string_extended"
require "nlp_toolz/helpers/tmp_file"

# NLP Tools
require "nlp_toolz/home"
require "nlp_toolz/load_jars"
require "nlp_toolz/language"
require "nlp_toolz/sentences"
require "nlp_toolz/pos_tags"
require "nlp_toolz/tokens"
require "nlp_toolz/parser"


module NlpToolz
  
  
  module_function
  
  def check_dependencies
    unless Dir.exist?(File.join(NlpToolz::HOME,'models')) && Dir.exist?(File.join(NlpToolz::HOME,'jars'))
      $stdout.puts "\n--> models and jars not installed,"
      $stdout.puts "    install it by running:"
      $stdout.puts "--> $ nlp_toolz init\n".green
      exit
    end
  end
  
  def get_lang(input)
    NlpToolz::Language.get_language(input)
  end

  def get_sentences(input,lang = nil)
    text = NlpToolz::Sentences.new(input,lang)
    text.split_into_sentences if text.has_model?
  end

  def tokenize_sentence(input,lang = nil)
    sentence = NlpToolz::Tokens.new(input,lang)
    sentence.tokenize
  end

  def tokenize_text(input,lang = nil)
    tokenized_text = []
    get_sentences(input,lang).each do |sentence|
      tokenized_text << tokenize_sentence(sentence,lang)
    end
  
    tokenized_text
  end

  def tag_sentence(input,lang = nil)
    sentence = NlpToolz::PosTags.new(input,lang)
    sentence.get_pos_tags if sentence.has_model?
  end

  def tag_text(input,lang = nil)
    tagged_text = []
    get_sentences(input,lang).each do |sentence|
      tagged_text << tag_sentence(sentence,lang)
    end
  
    tagged_text
  end

  def parse_sentence(input,lang = nil)
    text = NlpToolz::Parser.new(input,lang)
    text.parse_text
  
    text.parse_hash
  end

  def parse_text(input,lang = nil)
    parsed_text = []
    get_sentences(input,lang).each do |sentence|
      parsed_text << parse_sentence(sentence,lang)
    end
  
    parsed_text
  end
  
end
