module RPetri
  class Net
    extend DSL::ClassMethods
    include Builder
    include Runner
  end
end
