require 'jbuilder/jbuilder_template'
module JbuilderOptionals
  def optional!(key, val)
    set!(key, val) if @contains&.any?{|i| i == key}
  end

  def optional_partial!(*args)
    key = args.first.split('/').last
    partial_contains = ::Hash === @contains.last ? @contains.last[key.to_sym] : nil
    return unless @contains&.any?{|i| i.to_s == key.to_s} || @contains.last&.keys&.any?{|i| i.to_s == key.to_s}
    if ::Hash === args.last
      args.last[:contains] = partial_contains
    else
      args.push(contains: partial_contains)
    end
    if key.to_s == key.to_s.singularize
      set!key do
        partial!(*args)
      end
    else
      set!key do
        array! args.last[key.to_sym] do |record|
          args.last[key.to_s.singularize.to_sym] = record
          partial!(*args)
        end
      end
    end
  end

  def partial!(*args)
    @contains = args.last&.fetch(:contains, nil)
    super(*args)
  end
end

class JbuilderTemplate < Jbuilder
  prepend ::JbuilderOptionals
end