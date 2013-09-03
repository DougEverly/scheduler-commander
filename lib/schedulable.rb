class Schedulable
  
  @@info = "This is the base Schedulable."
  
  def self.info
    @@info
  end
  
  def initialize(args = [])
    @args = args
    puts @args
  end

  def call(job)
    
  end

end

class Work < Schedulable
  
  @@info = "Displays some text."
  
  def initialize(args = [])
    super
  end
  
  def call(job)
      puts "Some work here #{@args.join}"
  end

end

class Looper < Schedulable
  
  # @@info = "Loops."
  
  def initialize(args = [])
    super
  end
  
  def call(job)
      puts "Loop"
  end

end


