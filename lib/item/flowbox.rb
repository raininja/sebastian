class Sebastian::Item::FlowBox < Sebastian::Item
  @@defaults = {
    flowbox_orientation: Clutter::FlowOrientation::VERTICAL
  }.merge(@@defaults)
  
  def initialize(options = {})
    super()

    @state[:children] = []
    @state[:options] = {
      orientation: @@defaults[:flowbox_orientation]
    }.merge(options)

    on_init do |state, main|
      box = Clutter::Actor.new
      box.layout_manager = Clutter::FlowLayout.new state[:options][:orientation]

      state[:actor] = box
      init_children(main)
    end

    on_update do |state, main|
      state[:children].each do |child|
        child.update(main)
      end
    end
  end

  def init_children(main)
    @state[:children].each do |child|
      child.init(main)
      add_child(child)
    end
  end

  def add_child(child)
    kids = @state[:children]
    kids.push(child) unless kids.include? child
    #^ That guarantees @state[:children] to be
    #  a unique set, but if a child is added twice
    #  it means that the array won't reflect the
    #  actual layout as seen on screen.

    if @state.member? :actor
      act = child.state[:actor]
      if act.is_a? Clutter::Actor
        @state[:actor].add_child(act)
      else
        puts "Expected Clutter::Actor, found #{act.inspect}."
      end
    end
  end
end
