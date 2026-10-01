# @summary Renders a scalar or flat array as a YAML value (no stdlib needed)
function immich_kiosk::yaml_value(
  Variant[String, Numeric, Boolean, Array[Variant[String, Numeric, Boolean]]] $value
) >> String {
  case $value {
    Array: {
      $items = $value.map |$i| { immich_kiosk::yaml_value($i) }
      "[${join($items, ', ')}]"
    }
    String: {
      $escaped = regsubst($value, "'", "''", 'G')
      "'${escaped}'"
    }
    default: { String($value) }
  }
}
