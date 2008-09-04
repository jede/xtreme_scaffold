class XtremeModelGenerator < Rails::Generator::NamedBase
  default_options :skip_timestamps => false, :skip_migration => false, :skip_fixture => false
  
  attr_reader :parent_class_name,
              :parent_singular_name,
              :parent_plural_name
  
  def parent?
    !options[:parent].blank?
  end
  
  def initialize(runtime_args, runtime_options = {})
    super

    if parent?
      @parent_class_name, @parent_singular_name, @parent_plural_name = inflect_names(options[:parent])
    else
      @parent_name = nil
    end
  end

  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions class_path, class_name, "#{class_name}Test"

      # Model, test, and fixture directories.
      m.directory File.join('app/models', class_path)
      m.directory File.join('test/unit', class_path)
      m.directory File.join('test/fixtures', class_path)

      # Model class
      m.template 'model.rb',      File.join('app/models', class_path, "#{file_name}.rb")

      unless options[:skip_fixture] 
       	m.template 'fixtures.yml',  File.join('test/fixtures', "#{table_name}.yml")
      end

      unless options[:skip_migration]
        m.migration_template 'migration.rb', 'db/migrate', :assigns => {
          :migration_name => "Create#{class_name.pluralize.gsub(/::/, '')}"
        }, :migration_file_name => "create_#{file_path.gsub(/\//, '_').pluralize}"
      end
    end
  end

  protected
    def banner
      "Usage: #{$0} #{spec.name} ModelName [field:type, field:type]"
    end

    def add_options!(opt)
      opt.separator ''
      opt.separator 'Options:'
      opt.on("--skip-timestamps",
             "Don't add timestamps to the migration file for this model") { |v| options[:skip_timestamps] = v }
      opt.on("--skip-migration", 
             "Don't generate a migration file for this model") { |v| options[:skip_migration] = v }
      opt.on("--skip-fixture",
             "Don't generation a fixture file for this model") { |v| options[:skip_fixture] = v}
      opt.on("--belongs_to PARENT", "Name of model that this one belongs to in the routes.") do |parent|
        raise "No model given" if parent.empty?
        options[:parent] = parent
      end
    end
end
