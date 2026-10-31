import sys
name, feature_path, driver_path = sys.argv[1:4]
f = open(feature_path).read()
d = open(driver_path).read()
def swap(text, old, new):
    assert text.count(old) == 1, (name, old[:60])
    return text.replace(old, new)
block_predicate = ("        const BuiltinIntrinsicInfo* predicate = builtin ? check_target_feature_predicate(program, caller_map, node) : NULL;\n"
                   "        if (predicate != NULL)\n"
                   "        {\n"
                   "            CheckTargetFeatureError error = base;\n"
                   "            error.builtin = predicate;\n"
                   "            error.predicate = true;\n"
                   "            valid = check_target_feature_report(output, errors, error_count, error);\n"
                   "        }\n")
block_general = ("        const BuiltinIntrinsicInfo* lacked = builtin ? check_target_feature_builtin(program, maps, caller_map, node) : NULL;\n"
                 "        if (builtin)\n"
                 "        {\n"
                 "            CheckTargetFeatureError error = base;\n"
                 "            error.builtin = lacked;\n"
                 "            valid = valid && (lacked == NULL || check_target_feature_report(output, errors, error_count, error));\n"
                 "        }\n")
if name == "no-predicate":
    f = swap(f, "builtin ? check_target_feature_predicate(program, caller_map, node) : NULL;", "NULL;")
elif name == "prepass":
    f = swap(f, " ||\n                                 check_target_feature_predicate(program, last_map, node) != NULL;", ";")
elif name == "one-error":
    f = swap(f, "        if (builtin)\n        {\n            CheckTargetFeatureError error = base;\n            error.builtin = lacked;",
                "        if (builtin && predicate == NULL)\n        {\n            CheckTargetFeatureError error = base;\n            error.builtin = lacked;")
elif name == "order":
    general_first = block_general.replace("valid = valid && (lacked", "valid = (lacked")
    predicate_after = block_predicate.replace("            valid = check_target_feature_report(", "            valid = valid && check_target_feature_report(")
    f = swap(f, block_predicate + block_general, general_first + predicate_after + "        if (builtin)\n        {\n        }\n")
elif name == "boundary":
    f = swap(f, "stream->values[predicate].integer > 7", "stream->values[predicate].integer >= 7")
elif name == "unit-map":
    f = swap(f, "check_target_feature_predicate(program, caller_map, node)", "check_target_feature_predicate(program, maps->unit, node)")
elif name == "names":
    f = swap(f, ", \"__builtin_ia32_cmpsd\" };", " };")
elif name == "message":
    d = swap(d, "const char* features = error->predicate ? \"avx\" : error->builtin->features;", "const char* features = error->builtin->features;")
    d = swap(d, "const uint32_t features_length = error->predicate ? 3u : error->builtin->features_length;", "const uint32_t features_length = error->builtin->features_length;")
else:
    raise SystemExit("unknown mutant")
open(feature_path, 'w').write(f)
open(driver_path, 'w').write(d)
