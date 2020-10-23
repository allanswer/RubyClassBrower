class Browser
  def initialize
    super
    @bckCnt = 1
    @forwardCnt = 0
    @userInput = 'Browser Initialized'
    @currentClass = Object
    @classesTraveled = []
    updateHistory
    puts "Current Class: " + @currentClass.to_s
    puts "Current SuperClass: " + @currentClass.superclass.to_s
    @subClassArray = []
    @subClassArraySort = []
    # @subClassArray = ObjectSpace.each_object(Class).select { |klass| klass < @currentClass && klass.superclass == @currentClass}.to_a
    puts "Subclasses (In alphabetical order and with namespace):"
    # puts @subClassArray
    getSubclassInfo
    getInstanceMethods
    @backIsPressed = false

  end

  def start
    puts 'Browser started!!'
    while @userInput != 'q'
      getInput
      checkUserInput
    end
  end

  def getInput
    puts 'Enter command'
    @userInput = gets.chomp
  end

  def checkUserInput # s u v c b f
    if @userInput == 's'
      if @currentClass.superclass == nil
        puts "The superClass is Nil, try another command"
        return
      end
      @backIsPressed = false
      puts "Superclass is " + @currentClass.superclass.to_s
      @currentClass = @currentClass.superclass
      updateHistory
      puts "Current class switches to " + @currentClass.to_s
      getSubclassInfo
      getInstanceMethods
    elsif @userInput == 'u'
      @backIsPressed = false
      if @subClassArray.empty?
        puts 'No subclasses'
        return
      end
      puts 'Choose one of the subclasses as your current class'
      userNumberSub = gets.to_i - 1

      if userNumberSub > @subClassArray.length - 1
        puts "No this subclass."
        return
      end
      @currentClass = @subClassArray[userNumberSub]
      updateHistory
      puts "You choose " + @currentClass.to_s
      puts "Current Class: " + @currentClass.to_s
      puts "Superclass is " + @currentClass.superclass.to_s
      getSubclassInfo
      getInstanceMethods
    elsif @userInput == 'v' #need modify
      @backIsPressed = false
      inObject = @currentClass.new
      puts "Instance Variable : "
      puts inObject.instance_variables
      getInstanceVariables
    elsif @userInput == 'c'
      @backIsPressed = false
      selectedClass = gets.chomp
      @subClassArray.each do |klass|
        if klass.to_s.include? selectedClass
          puts "Switch to " + klass.to_s
          @currentClass = klass
          puts "Current Class: " + @currentClass.to_s
          puts "Superclass is " + @currentClass.superclass.to_s
          updateHistory
          getSubclassInfo
          getInstanceMethods
          return
        end
      end
      puts "No class is found."
    elsif @userInput == 'b'
      @bckCnt -= 1
      # puts "cnt " + @bckCnt.to_s
      if @bckCnt >=1
        puts "back to " + @classesTraveled[@bckCnt - 1].to_s
        @undoToPrevious = @currentClass
        @currentClass = @classesTraveled[@bckCnt - 1]
        getSubclassInfo
        getInstanceMethods
        @backIsPressed = true
      else
        @bckCnt = 1
        @backIsPressed = true
      end

    elsif @userInput == 'f' && @backIsPressed == true
      @currentClass = @undoToPrevious
      puts "Forward to: " + @currentClass.to_s
      getSubclassInfo
      getInstanceMethods
    end
  end

  def getSubclassInfo
    @subClassArray = ObjectSpace.each_object(Class).select { |klass| klass < @currentClass && klass.superclass == @currentClass}.to_a
    if @subClassArray[0] == nil
      puts "No subclasses"
      return
    end
    puts "Subclasses (In alphabetical order):"
    @subClassArray = merge_sort(@subClassArray)
    @subClassArray.each.with_index(1) do |klass, index|
      puts "#{index}: #{klass}"
    end
    # puts @subClassArray
    # removeSpecial
    # puts merge_sort(@@subClassArray)
  end

  def getInstanceMethods


    puts "Instance methods: (In alphabetical order)"
    merge_sort(@currentClass.instance_methods(false)).each.with_index(1) do |methods, index|
      puts "#{index}: #{methods}"
    end
  end

  def getInstanceVariables
    puts "Instance Variables: (In alphabetical order)"
    merge_sort(@currentClass.instance_variables).each.with_index(1) do |methods, index|
      puts "#{index}: #{methods}"
    end
  end

  def removeSpecial #for the purpose of sorting
    @subClassArray.each do |klass|
      if klass.to_s.include? "::"
        @subClassArraySort.push(klass.to_s.split(/::/).last)
      elsif klass.to_s.include? "<#"
        @subClassArraySort.push(klass.to_s.delete('#'))
      else
        @subClassArraySort = @subClassArraySort.push(klass.to_s)
      end
    end
  end

  def updateHistory
    if(@classesTraveled.length < 3)
    @classesTraveled.push(@currentClass)
    else
      @classesTraveled.shift
      @classesTraveled.push(@currentClass)
    end
    @bckCnt = @classesTraveled.length
    # puts "classesTraveled:"
    # puts @classesTraveled
    # puts "cnt " + @bckCnt.to_s
  end

  def merge(leftArray, rightArray)
    if leftArray.empty?
      rightArray
    elsif rightArray.empty?
      leftArray
    elsif leftArray.first.to_s.chars.first < rightArray.first.to_s.chars.first
      [leftArray.first] + merge(leftArray[1..leftArray.length], rightArray)
    else
      [rightArray.first] + merge(leftArray, rightArray[1..rightArray.length])
    end
  end

  def merge_sort(classArray)
    if classArray.length <= 1
      classArray
    else
      mid = (classArray.length / 2).floor
      left = merge_sort(classArray[0..mid - 1])
      right = merge_sort(classArray[mid..classArray.length])
      merge(left, right)
    end
  end
end
#

Browser1 = Browser.new
Browser1.start

