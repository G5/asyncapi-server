module ActiveModelSerializersFix
  def namespace_for_serializer
    @namespace_for_serializer ||=
      if Module.method_defined?(:parent)
        self.class.parent unless self.class.parent == Object
      else
        self.class.module_parent unless self.class.module_parent == Object
      end
  end
end