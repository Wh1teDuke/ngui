{.deadCodeElim: on.}
import pango except fontGetType, fontMapGetType
from glib import Gboolean
from gobject import GType
from pango_fc import FcFont
{.pragma: libpango, cdecl, dynlib: LIB_PANGO.}
type
  FT_Face = ptr object # dummy objects!

when (ENABLE_ENGINE):
  type
    OTTag* = uint32
  template pangoOtTagMake*(c1, c2, c3, c4: untyped): untyped =
    (cast[OTTag](ft_Make_Tag(c1, c2, c3, c4)))

  template pangoOtTagMakeFromString*(s: untyped): untyped =
    (pangoOtTagMake((cast[cstring](s))[0], (cast[cstring](s))[1], (cast[cstring](s))[2], (cast[cstring](s))[3]))

  type
    OTInfo* =  ptr OTInfoObj
    OTInfoPtr* = ptr OTInfoObj
    OTInfoObj* = object

    OTBuffer* =  ptr OTBufferObj
    OTBufferPtr* = ptr OTBufferObj
    OTBufferObj* = object

    OTRuleset* =  ptr OTRulesetObj
    OTRulesetPtr* = ptr OTRulesetObj
    OTRulesetObj* = object

  type
    OTTableType* {.size: sizeof(cint), pure.} = enum
      GSUB, GPOS
  const
    OT_ALL_GLYPHS* = cuint(0x0000FFFF)
    OT_NO_FEATURE* = cuint(0x0000FFFF)
    OT_NO_SCRIPT* = cuint(0x0000FFFF)
    OT_DEFAULT_LANGUAGE* = cuint(0x0000FFFF)
  type
    OTGlyph* =  ptr OTGlyphObj
    OTGlyphPtr* = ptr OTGlyphObj
    OTGlyphObj* = object
      glyph*: uint32
      properties*: cuint
      cluster*: cuint
      component*: cushort
      ligID*: cushort
      internal*: cuint

  type
    OTFeatureMap* =  ptr OTFeatureMapObj
    OTFeatureMapPtr* = ptr OTFeatureMapObj
    OTFeatureMapObj* = object
      featureName*: array[5, char]
      propertyBit*: culong

  type
    OTRulesetDescription* =  ptr OTRulesetDescriptionObj
    OTRulesetDescriptionPtr* = ptr OTRulesetDescriptionObj
    OTRulesetDescriptionObj* = object
      script*: Script
      language*: Language
      staticGsubFeatures*: OTFeatureMap
      nStaticGsubFeatures*: cuint
      staticGposFeatures*: OTFeatureMap
      nStaticGposFeatures*: cuint
      otherFeatures*: OTFeatureMap
      nOtherFeatures*: cuint

  template pangoTypeOtInfo*(): untyped =
    (otInfoGetType())

  template pangoOtInfo*(`object`: untyped): untyped =
    (gTypeCheckInstanceCast(`object`, pangoTypeOtInfo, OTInfoObj))

  template pangoIsOtInfo*(`object`: untyped): untyped =
    (gTypeCheckInstanceType(`object`, pangoTypeOtInfo))

  proc infoGetType*(): GType {.importc: "pango_ot_info_get_type", libpango.}
  template pangoTypeOtRuleset*(): untyped =
    (otRulesetGetType())

  template pangoOtRuleset*(`object`: untyped): untyped =
    (gTypeCheckInstanceCast(`object`, pangoTypeOtRuleset, OTRulesetObj))

  template pangoIsOtRuleset*(`object`: untyped): untyped =
    (gTypeCheckInstanceType(`object`, pangoTypeOtRuleset))

  proc rulesetGetType*(): GType {.importc: "pango_ot_ruleset_get_type",
                                      libpango.}
  proc infoGet*(face: FT_Face): OTInfo {.
      importc: "pango_ot_info_get", libpango.}
  proc findScript*(info: OTInfo; tableType: OTTableType;
                             scriptTag: OTTag; scriptIndex: var cuint): Gboolean {.
      importc: "pango_ot_info_find_script", libpango.}
  proc findLanguage*(info: OTInfo; tableType: OTTableType;
                               scriptIndex: cuint; languageTag: OTTag;
                               languageIndex: var cuint;
                               requiredFeatureIndex: var cuint): Gboolean {.
      importc: "pango_ot_info_find_language", libpango.}
  proc findFeature*(info: OTInfo; tableType: OTTableType;
                              featureTag: OTTag; scriptIndex: cuint;
                              languageIndex: cuint; featureIndex: var cuint): Gboolean {.
      importc: "pango_ot_info_find_feature", libpango.}
  proc listScripts*(info: OTInfo; tableType: OTTableType): ptr OTTag {.
      importc: "pango_ot_info_list_scripts", libpango.}
  proc listLanguages*(info: OTInfo; tableType: OTTableType;
                                scriptIndex: cuint; languageTag: OTTag): ptr OTTag {.
      importc: "pango_ot_info_list_languages", libpango.}
  proc listFeatures*(info: OTInfo; tableType: OTTableType;
                               tag: OTTag; scriptIndex: cuint;
                               languageIndex: cuint): ptr OTTag {.
      importc: "pango_ot_info_list_features", libpango.}
  proc bufferNew*(font: FcFont): OTBuffer {.
      importc: "pango_ot_buffer_new", libpango.}
  proc destroy*(buffer: OTBuffer) {.
      importc: "pango_ot_buffer_destroy", libpango.}
  proc clear*(buffer: OTBuffer) {.
      importc: "pango_ot_buffer_clear", libpango.}
  proc setRtl*(buffer: OTBuffer; rtl: Gboolean) {.
      importc: "pango_ot_buffer_set_rtl", libpango.}
  proc `rtl=`*(buffer: OTBuffer; rtl: Gboolean) {.
      importc: "pango_ot_buffer_set_rtl", libpango.}
  proc addGlyph*(buffer: OTBuffer; glyph: cuint;
                             properties: cuint; cluster: cuint) {.
      importc: "pango_ot_buffer_add_glyph", libpango.}
  proc getGlyphs*(buffer: OTBuffer;
                              glyphs: var OTGlyph; nGlyphs: var cint) {.
      importc: "pango_ot_buffer_get_glyphs", libpango.}
  proc output*(buffer: OTBuffer; glyphs: GlyphString) {.
      importc: "pango_ot_buffer_output", libpango.}
  proc setZeroWidthMarks*(buffer: OTBuffer;
                                      zeroWidthMarks: Gboolean) {.
      importc: "pango_ot_buffer_set_zero_width_marks", libpango.}
  proc `zeroWidthMarks=`*(buffer: OTBuffer;
                                      zeroWidthMarks: Gboolean) {.
      importc: "pango_ot_buffer_set_zero_width_marks", libpango.}
  proc rulesetGetForDescription*(info: OTInfo;
                                       desc: OTRulesetDescription): OTRuleset {.
      importc: "pango_ot_ruleset_get_for_description", libpango.}
  proc rulesetNew*(info: OTInfo): OTRuleset {.
      importc: "pango_ot_ruleset_new", libpango.}
  proc rulesetNewFor*(info: OTInfo; script: Script;
                            language: Language): OTRuleset {.
      importc: "pango_ot_ruleset_new_for", libpango.}
  proc rulesetNewFromDescription*(info: OTInfo;
                                        desc: OTRulesetDescription): OTRuleset {.
      importc: "pango_ot_ruleset_new_from_description", libpango.}
  proc addFeature*(ruleset: OTRuleset;
                                tableType: OTTableType; featureIndex: cuint;
                                propertyBit: culong) {.
      importc: "pango_ot_ruleset_add_feature", libpango.}
  proc maybeAddFeature*(ruleset: OTRuleset;
                                     tableType: OTTableType;
                                     featureTag: OTTag; propertyBit: culong): Gboolean {.
      importc: "pango_ot_ruleset_maybe_add_feature", libpango.}
  proc maybeAddFeatures*(ruleset: OTRuleset;
                                      tableType: OTTableType;
                                      features: OTFeatureMap;
                                      nFeatures: cuint): cuint {.
      importc: "pango_ot_ruleset_maybe_add_features", libpango.}
  proc getFeatureCount*(ruleset: OTRuleset;
                                     nGsubFeatures: var cuint;
                                     nGposFeatures: var cuint): cuint {.
      importc: "pango_ot_ruleset_get_feature_count", libpango.}
  proc featureCount*(ruleset: OTRuleset;
                                     nGsubFeatures: var cuint;
                                     nGposFeatures: var cuint): cuint {.
      importc: "pango_ot_ruleset_get_feature_count", libpango.}
  proc substitute*(ruleset: OTRuleset;
                                buffer: OTBuffer) {.
      importc: "pango_ot_ruleset_substitute", libpango.}
  proc position*(ruleset: OTRuleset;
                              buffer: OTBuffer) {.
      importc: "pango_ot_ruleset_position", libpango.}
  proc toScript*(scriptTag: OTTag): Script {.
      importc: "pango_ot_tag_to_script", libpango.}
  proc tagFromScript*(script: Script): OTTag {.
      importc: "pango_ot_tag_from_script", libpango.}
  proc toLanguage*(languageTag: OTTag): Language {.
      importc: "pango_ot_tag_to_language", libpango.}
  proc tagFromLanguage*(language: Language): OTTag {.
      importc: "pango_ot_tag_from_language", libpango.}
  proc hash*(desc: OTRulesetDescription): cuint {.
      importc: "pango_ot_ruleset_description_hash", libpango.}
  proc equal*(desc1: OTRulesetDescription;
                                      desc2: OTRulesetDescription): Gboolean {.
      importc: "pango_ot_ruleset_description_equal", libpango.}
  proc copy*(desc: OTRulesetDescription): OTRulesetDescription {.
      importc: "pango_ot_ruleset_description_copy", libpango.}
  proc free*(desc: OTRulesetDescription) {.
      importc: "pango_ot_ruleset_description_free", libpango.}
