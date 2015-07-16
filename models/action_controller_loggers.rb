class RedmineMetricsDb < ActiveRecord::Base
  self.abstract_class = true
  establish_connection(YAML::load(File.open('config/database_metrics.yml')))
  logger = Logger.new(File.open('log/database_metrics.log', 'w'))
end

class ActionControllerLoggers < RedmineMetricsDb
  self.table_name = 'action_controller_loggers'
end
