library map;

import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:layrz_models/layrz_models.dart' hide Point;
import 'package:layrz_theme/layrz_theme.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// Layers
part 'src/layers/tile.dart';
part 'src/layers/toolbar.dart';

// General
part 'src/button.dart';
part 'src/helpers.dart';
part 'src/constants.dart';
part 'src/dialogs/street_view.dart';
part 'src/projection.dart';

// Events
part 'src/events/controller.dart';
part 'src/events/events.dart';

// Dialogs
part 'src/dialogs/change_layer.dart';
