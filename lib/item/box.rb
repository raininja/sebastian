class Sebastian::Item::Box < Sebastian::Item
  def initialize(options = {})
    init = Proc.new do |state, conf|
      opt = state[:options]
      box = Clutter::Actor.new

      box.layout_manager = opt[:layout] || begin
        layout = Clutter::BoxLayout.new
        layout.spacing = 20
        layout.orientation = Clutter::Orientation::VERTICAL
        layout
      end
      
      conf.stage.add_child(box)
      state[:actor] = box
      init_children(conf)
    end
    super(&init)

    @state[:options] = {
    }.merge(options)
    @state[:children] = []

    on_update do |state, conf|
      state[:children].each do |child|
        child.update(conf)
      end
    end
  end

  def init_children(conf)
    @state[:children].each do |child|
      child.init(conf)
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
