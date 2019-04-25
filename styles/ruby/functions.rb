require 'sass'

module FunctionsCNX
  def rb_oer_font_scale_multiplier(level, ratios=[1.3,1.5])
    return Sass::Script::Number.new(1) if level.value.zero?
    ratio_counts = Array.new(ratios.length, 0)
    next_ratio_index = nil
    until ratio_counts.sum == level.value.abs
      next_ratio_index = ratios.zip(ratio_counts).map{|ratio, power| ratio ** (power+1)}.each_with_index.min_by{|val, i| val}[1]
      ratio_counts[next_ratio_index] += 1
    end
    return Sass::Script::Number.new(ratios[next_ratio_index] ** ratio_counts[next_ratio_index]).to_f ** (level.value.negative? ? -1 : 1)
  end

  def rb_list_contains(list, val)
    return Sass::Script::Bool.new(list.value.include?(val))
  end

  def rb_resource_exists(path)
    return Sass::Script::Bool.new(File.exist?(File.expand_path(path.value, File.expand_path("../..", __FILE__))))
  end

end

module Sass::Script::Functions
  include FunctionsCNX
end

