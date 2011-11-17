module Osheet::Associations

  def self.included(receiver)
    receiver.send(:extend, ClassMethods)
  end

  module ClassMethods

    # A has many esque association helper
    #  - will provide a collection reader
    #  - will define a 'singular' item method for adding to the collection
    #  - will support adding to the collection both by black and template
    def hm(collection)
      unless collection.to_s =~ /s$/
        raise ArgumentError, "association item names must end in 's'"
      end
      plural = collection.to_s
      singular = plural.to_s.sub(/s$/, '')
      klass = Osheet.const_get(singular.capitalize)

      # define collection reader
      self.send(:define_method, plural, Proc.new do
        set_ivar(plural, []) if get_ivar(plural).nil?
        get_ivar(plural)
      end)

      # define collection item writer
      self.send(:define_method, singular) do |*args, &block|
        set_ivar(plural, []) if get_ivar(plural).nil?
        push_ivar(plural, if self.respond_to?(:workbook)
          # on: worksheet, column, row
          # creating: column, row, cell
          worksheet = self.respond_to?(:worksheet) ? self.worksheet : self
          if self.workbook && (template = self.workbook.templates.get(singular, args.first))
            # add by template
            klass.new(self.workbook, worksheet, *args[1..-1], &template)
          else
            # add by block
            if not self.respond_to?(:row)
              # creating: column, row
              klass.new(self.workbook, worksheet, &block)
            else
              # creating: cell
              klass.new(nil, self.workbook, worksheet, &block)
            end
          end
        else
          # on: workbook
          # creating: worksheet
          if (template = self.templates.get(singular, args.first))
            # add by template
            klass.new(self, *args[1..-1], &template)
          else
            # add by block
            klass.new(self, &block)
          end
        end)
      end

    end

  end

end
