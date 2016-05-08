require "active_record"
require 'yaml'
require 'pry'
require 'csv'
Dir["./app/**/*.rb"].each {|file| require file }

db_config = YAML::load(File.open('config/database.yml'))

namespace :db do
  desc "Create the database"
  task :create do
    ActiveRecord::Base.establish_connection(db_config)
    puts "Database created."
  end

  desc "Migrate the database"
  task :migrate do
    ActiveRecord::Base.establish_connection(db_config)
    ActiveRecord::Migrator.migrate("db/migrate/")
    puts "Database migrated."
  end

  desc "Drop the database"
  task :drop do
    rm db_config['database'] if File.file? db_config['database']
    puts "Database Dropped"
  end

  desc "Reset the database"
  task :reset => [:drop, :create, :migrate]
end

namespace :maze do
  desc "Load from csv"
  task :load, [:width, :height, :filename] do |t, args|
    width = args[:width].to_i

    # Clear all previous records
    Rake::Task["db:reset"].invoke
    ActiveRecord::Base.establish_connection(db_config)

    rows = CSV.readlines("./db/data/#{args[:filename]}.csv")
    rows[1..-1].each do |row|
      start = row[4].strip == 'true' ? true : false
      _end = row[5].strip == 'true' ? true : false
      Box.create(
        left: row[0],
        top: row[1],
        right: row[2],
        bottom: row[3],
        start: start,
        end: _end
        )
    end
    Box.order(:id).each do |box|
      current = box.id
      box.left_adjacent_box = Box.where(id: current - 1) .first if (current - 1 > 0)
      box.top_adjacent_box = Box.where(id: current - width) .first if (current - width > 0)
      box.right_adjacent_box = Box.where(id: current + 1).first
      box.bottom_adjacent_box = Box.where(id: current + width).first
      box.save
    end
    puts "Loaded Maze"
  end

  desc "Solve the puzzle"
  task :solve do
    ActiveRecord::Base.establish_connection(db_config)
    raise "No start box!" unless start_box = Box.where(start: true).first
    raise "No end box!" unless end_box = Box.where(end: true).first
    
    turning_points = []
    current_box = start_box
    solved_path = []
    while current_box != end_box do
      solved_path.push(current_box.id)
      current_box.update_attributes(traversed: true)
      previous_box = current_box
      current_box = current_box.next_traversal
      current_box.update_attributes(traversed: true) if current_box
      if previous_box.next_traversable_boxes.count >= 1
        previous_box.update_attributes(turning_point: true)
        turning_points.push(previous_box)
      end
      if current_box.nil?
        puts "Huh, hit a dead end at Box No #{previous_box.id}. Gonna Backtrack to the last Turning Point"
        puts "*" * 30
        current_box = turning_points.pop
        raise "Unsolvable Puzzle!" if current_box.nil?
        current_box.update_attributes(turning_point: false) if current_box.next_traversable_boxes.count == 1

        # Remove all elements from now to the last Turning Point
        last_turning_point_index = solved_path.index(current_box.id)
        solved_path.slice!(last_turning_point_index..-1)
      end
    end
    puts "Solved Path: "
    print "Start -> "
    solved_path.each { |box_id| print "#{box_id} -> " } 
    puts "End"

    Box.update_all(traversed: false)
    Box.update_all(turning_point: false)
  end
end