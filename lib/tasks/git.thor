#!/usr/bin/env ruby -wKU

#require File.join(File.dirname(__FILE__), 'thesis')

class Git < Thor
#  include Thesis
  include Thor::Actions
  source_root '.'
  
  desc "cpa", "commit and push all changes made to the current repo"
  method_options %w(message -m) => :required
  def cpa
    puts git(:commit, '-a', '-m', "\"#{options[:message]}\"")
    puts git(:push)
    puts thor('git:status', [])
  end
  
  desc "status", "Runs git status on all repos in parent dir"
  def status
    nothing_to_commit_or_push = true
    git_repositories.each do |repo|
      inside repo do
        name, msg = repo.dup, nil
        status = git(:status)
        if opts = ahead?(status)
          name = repo.yellow
          msg = "#{opts[:commits]} #{opts[:commits] == 1 ? 'commit' : 'commits'} to be pushed"
        end
        if modified?(status)
          name = repo.red
          msg = "there are uncommitted changes"
        end
        unless msg.nil?
          nothing_to_commit_or_push = false
          puts name.rjust(20) + '  ' + msg
        end
      end
    end
    if nothing_to_commit_or_push
      success "Nothing to commit or push"
    end
  end
  
  desc "pull", "Runs git pull on all repos in parent dir"
  def pull
    git_repositories.each do |repo|
      inside repo do
        git(:pull, '-v')
      end
    end
  end
  
  private
  
  def git_repositories(glob = 'diplom')
    repos = []
    ['./*', '..', '../*'].each do |path|
      gits = Dir[File.join(path, '.git')]
      unless gits.empty?
        repos.concat gits.map { |path| path.gsub(/(\/\.git)$/, '') }
      end
    end
    repos.select { |repo| repo =~ /#{glob || '.+'}/ }
  end
  
  def git(*args)
    arr = [:git, *args]
    out = `#{arr.join(' ')}`
  end
  
  def ahead?(status)
    arr = status.scan(/Your branch is ahead of '([^']+)' by (\d+) commit/).first
    unless arr.nil?
      {:branch => arr[0], :commits => arr[1]}
    else
      nil
    end
  end
  
  def modified?(status)
    !(status =~ /(changed but not updated|changes to be committed)/i).nil?
  end
  
end