require 'jbuilder/jbuilder_template'
module JbuilderOptionals
  def optional!(key, val)
    set!(key, val) if @contains&.any?{|i| i == key}
  end

  def optional_partial!(*args)
    partial_contains = ::Hash === @contains.last ? @contains.last[args.last[:key]] : nil
    return unless  @contains&.any?{|i| i == args.last[:key]} || @contains.last&.keys&.any?{|i| i == args.last[:key]}
    if ::Hash === args.last
      args.last[:contains] = partial_contains
    else
      args.push(contains: partial_contains)
    end
    if args.last[:key].to_s == args.last[:key].to_s.singularize
      set!args.last[:key] do
        partial!(*args)
      end
    else
      set!args.last[:key] do
        array!args.last[args.last[:key]] do |record|
          args.last[args.last[:key].to_s.singularize.to_sym] = record
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