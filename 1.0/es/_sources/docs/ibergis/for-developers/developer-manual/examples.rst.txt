========
Examples
========

.. only:: html

   .. contents::
      :local:

This section provides practical, high-level examples for developers working with the IberGIS plugin. The goal is to illustrate **typical workflows**, not to document every implementation detail.

The examples below build on the concepts described in :doc:`python` and :doc:`dbmodel`.

Typical Development Tasks
=========================

Common changes you will perform in IberGIS include:

- Adding or modifying **QGIS Processing algorithms**.
- Creating new **toolbars, buttons or dialogs**.
- Reading and writing **configuration values** for new features.
- Evolving the **database model** while keeping existing projects working.

The following sections walk through representative examples of each area.

Example 1 - Creating a New Processing Algorithm
===============================================

This example describes the typical steps to add a new QGIS Processing algorithm to IberGIS.

Locate the Processing Package
-----------------------------

Processing algorithms are implemented under the plugin root in::

   core/processing/

Each ``*.py`` file usually exposes one or more algorithms that appear in the QGIS Processing Toolbox under the IberGIS groups.

Create and Register the Algorithm
---------------------------------
There is a QGIS Official Guide for Processing Algorithms that can be found at https://docs.qgis.org/3.40/en/docs/pyqgis_developer_cookbook/processing.html.

1. Choose a clear, descriptive name for your algorithm file, for example::

      core/processing/check_custom_rule.py

2. Implement your algorithm class following the standard QGIS Processing API (subclassing ``QgsProcessingAlgorithm``). Reuse utilities from ``lib/tools_qgis.py`` and ``core/utils`` whenever possible for logging, configuration and data access.

3. Keep line length under 120 characters and follow the naming conventions described in :doc:`python`.

4. Register the algorithm in the appropriate provider file::

      core/processing/drain_provider.py
      core/processing/drain_mesh_provider.py

   - Import your new algorithm class.
   - Add an instance of it in the provider's ``loadAlgorithms`` method.

5. Reload the plugin in QGIS and verify that the algorithm appears in the Processing Toolbox and behaves as expected.

Code Example - Minimal Processing Algorithm
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Below is a minimal implementation of a Processing algorithm following the IberGIS patterns. Create this file as ``core/processing/check_custom_rule.py``:

.. code-block:: python

   """
   This file is part of IberGIS
   The program is free software: you can redistribute it and/or modify it under the terms of the GNU
   General Public License as published by the Free Software Foundation, either version 3 of the License,
   or (at your option) any later version.
   """
   # -*- coding: utf-8 -*-

   from qgis.core import (
       QgsProcessingAlgorithm,
       QgsProcessingParameterVectorLayer,
       QgsProcessingParameterBoolean,
       QgsProcessing,
       QgsVectorLayer
   )
   from qgis.PyQt.QtCore import QCoreApplication

   from ...lib import tools_qgis
   from ... import global_vars


   class CheckCustomRule(QgsProcessingAlgorithm):
       """Algorithm to validate features against a custom rule."""

       # Parameter identifiers
       INPUT_LAYER = 'INPUT_LAYER'
       BOOL_SHOW_ONLY_ERRORS = 'BOOL_SHOW_ONLY_ERRORS'

       def name(self):
           """Unique algorithm identifier (lowercase, no spaces)."""
           return 'check_custom_rule'

       def displayName(self):
           """Human-readable name shown in the Processing Toolbox."""
           return self.tr('Check Custom Rule')

       def createInstance(self):
           """Return a new instance of the algorithm."""
           return CheckCustomRule()

       def initAlgorithm(self, config=None):
           """Define the algorithm inputs and outputs."""
           self.addParameter(
               QgsProcessingParameterVectorLayer(
                   self.INPUT_LAYER,
                   self.tr('Input layer'),
                   types=[QgsProcessing.SourceType.VectorPolygon]
               )
           )
           self.addParameter(
               QgsProcessingParameterBoolean(
                   name=self.BOOL_SHOW_ONLY_ERRORS,
                   description=self.tr('Show only errors'),
                   defaultValue=False
               )
           )

       def processAlgorithm(self, parameters, context, feedback):
           """Execute the algorithm logic."""
           # Get parameters
           layer: QgsVectorLayer = self.parameterAsVectorLayer(
               parameters, self.INPUT_LAYER, context
           )
           show_only_errors: bool = self.parameterAsBool(
               parameters, self.BOOL_SHOW_ONLY_ERRORS, context
           )

           # Get database connection from global_vars
           dao = global_vars.gpkg_dao_data.clone()
           if dao is None:
               feedback.pushWarning(self.tr('ERROR: No database connection found'))
               return {}

           feedback.setProgressText(self.tr('Validating layer...'))

           # Your validation logic here
           feature_count = layer.featureCount()
           for i, feature in enumerate(layer.getFeatures()):
               if feedback.isCanceled():
                   break
               # Perform validation on each feature
               feedback.setProgress(int((i / feature_count) * 100))

           dao.close_db()
           return {}

       def postProcessAlgorithm(self, context, feedback):
           """Called after processAlgorithm, runs on main thread."""
           feedback.setProgressText(self.tr('Validation complete.'))
           return {}

       def shortHelpString(self):
           """Help text shown in the algorithm dialog."""
           return self.tr("""This algorithm validates features against a custom rule.
           
                           Results are reported as errors and warnings in the log.""")

       def helpUrl(self):
           return "https://github.com/drain-iber"

       def tr(self, string: str):
           """Translate string using QCoreApplication."""
           return QCoreApplication.translate('Processing', string)

Code Example - Register in Provider
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Add the algorithm to the provider in ``core/processing/drain_provider.py``:

.. code-block:: python

   # At the top of drain_provider.py, add the import:
   from .check_custom_rule import CheckCustomRule


   class DrainProvider(QgsProcessingProvider):

       def __init__(self, plugin_dir):
           QgsProcessingProvider.__init__(self)
           self.plugin_dir = plugin_dir

       def loadAlgorithms(self):
           """Loads all algorithms belonging to this provider."""
           # ... existing algorithms ...

           # Add your new algorithm
           self.addAlgorithm(CheckCustomRule())

       def id(self):
           return 'IberGISProvider'

       def name(self):
           return self.tr('IberGIS')

Example 2 - Adding a New Toolbar Button and Dialog
==================================================

This example shows how to expose new functionality through the QGIS GUI.

Decide Where the Feature Belongs
--------------------------------

- **Core logic** for the feature should live in ``core`` or ``core/utils``.
- **UI elements** (dialogs, dock widgets) should live under ``core/ui``.
- **Toolbar/button wiring** usually lives under ``core/toolbars`` or is triggered from ``main.py`` / ``core/load_project_menu.py``.

Create the Dialog
-----------------

1. Design a new form using Qt Designer and save it under::

      core/ui/toolbars/<toolbar_name>/<dialog_name>.ui

2. Register the UI class in ``core/ui/ui_manager.py``.

3. Create a button class that inherits from ``DrAction`` and opens your dialog.

Code Example - Register Dialog in ui_manager.py
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Add your dialog class to ``core/ui/ui_manager.py``:

.. code-block:: python

   # In core/ui/ui_manager.py

   # Add the UI loader for your new dialog
   FORM_CLASS = _get_ui_class('custom_feature.ui', 'utilities')


   class DrCustomFeatureUi(DrDialog, FORM_CLASS):
       """Dialog for the custom feature."""
       pass

Code Example - Create Button Class
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Create the button class in ``core/toolbars/utilities/custom_feature_btn.py``:

.. code-block:: python

   """
   This file is part of IberGIS
   The program is free software: you can redistribute it and/or modify it under the terms of the GNU
   General Public License as published by the Free Software Foundation, either version 3 of the License,
   or (at your option) any later version.
   """
   # -*- coding: utf-8 -*-

   from functools import partial

   from ..dialog import DrAction
   from ...ui.ui_manager import DrCustomFeatureUi
   from ...utils import tools_dr
   from ....lib import tools_qt, tools_qgis
   from .... import global_vars


   class DrCustomFeatureButton(DrAction):
       """Button for custom feature functionality."""

       def __init__(self, icon_path, action_name, text, toolbar, action_group):
           super().__init__(icon_path, action_name, text, toolbar, action_group)

       def clicked_event(self):
           """Handle button click - open the dialog."""
           self._open_dialog()

       def _open_dialog(self):
           """Open the custom feature dialog."""
           # Create dialog instance
           self.dlg = DrCustomFeatureUi()

           # Load saved position and size
           tools_dr.load_settings(self.dlg)

           # Connect signals
           self.dlg.btn_run.clicked.connect(self._execute_feature)
           self.dlg.btn_close.clicked.connect(partial(tools_dr.close_dialog, self.dlg))
           self.dlg.rejected.connect(partial(tools_dr.close_dialog, self.dlg))

           # Open dialog with translation support
           tools_dr.open_dialog(self.dlg, dlg_name='custom_feature')

       def _execute_feature(self):
           """Execute the custom feature logic."""
           # Get values from dialog widgets
           input_value = tools_qt.get_text(self.dlg, self.dlg.txt_input)

           if not input_value:
               tools_qgis.show_warning('Please enter a value')
               return

           # Your feature logic here
           tools_qgis.show_info(f'Feature executed with value: {input_value}')

           # Close dialog after execution
           tools_dr.close_dialog(self.dlg)

Code Example - Export Button in buttons.py
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Export the button class in ``core/toolbars/buttons.py``:

.. code-block:: python

   # In core/toolbars/buttons.py, add the import:

   # Utilities
   from .utilities.custom_feature_btn import DrCustomFeatureButton

Wire the Button in drain.config
-------------------------------

Register the button in ``config/drain.config``:

.. code-block:: ini

   [toolbars]
   list_toolbars = main, utilities
   main = 01, 02, 03, 04, 05
   utilities = 21, 22, 23, 24, 25, 32, 33  ; Added 33 for new button

   [buttons_def]
   ; ... existing buttons ...
   33 = DrCustomFeatureButton

   [buttons_tooltip]
   ; ... existing tooltips ...
   33 = Custom Feature

After these changes, reload the plugin and the new button will appear in the utilities toolbar.

Example 3 - Using Configuration and Global State
================================================

Many IberGIS features are controlled by configuration files and global variables. This example shows how to add a new user-configurable option.

Configuration Files Overview
----------------------------

IberGIS uses several configuration files managed through ``global_vars.configs``:

- **init.config**: User configuration stored in the user folder (persistent across sessions)
- **session.config**: Session-specific settings (dialog positions, temporary values)
- **drain.config**: Plugin configuration (toolbars, buttons, system settings)
- **user_params.config**: Default values for user parameters

Define the Configuration Key
----------------------------

1. Decide whether the setting belongs to **user config** (per installation) or **project config** (per project). See the explanations in :doc:`python` and :doc:`dbmodel`.

2. Add default values in ``config/user_params.config`` if needed:

.. code-block:: ini

   [custom_feature]
   enabled = True
   threshold = 0.5
   max_iterations = 100

Code Example - Read Configuration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use ``tools_dr.get_config_parser()`` to read configuration values:

.. code-block:: python

   from core.utils import tools_dr


   def get_custom_feature_settings():
       """Read custom feature settings from configuration file."""

       # Read from user config file 'init.config'
       enabled = tools_dr.get_config_parser(
           section='custom_feature',
           parameter='enabled',
           config_type='user',
           file_name='init'
       )

       # Read from session config (temporary values)
       last_value = tools_dr.get_config_parser(
           section='custom_feature',
           parameter='last_value',
           config_type='user',
           file_name='session'
       )

       # Read from project config 'drain.config'
       default_threshold = tools_dr.get_config_parser(
           section='custom_feature',
           parameter='threshold',
           config_type='project',
           file_name='drain'
       )

       return {
           'enabled': enabled == 'True',
           'last_value': last_value,
           'threshold': float(default_threshold) if default_threshold else 0.5
       }


   def is_custom_feature_enabled():
       """Check if custom feature is enabled."""
       value = tools_dr.get_config_parser(
           'custom_feature', 'enabled', 'user', 'init'
       )
       return value == 'True'

Code Example - Write Configuration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use ``tools_dr.set_config_parser()`` to write configuration values:

.. code-block:: python

   from core.utils import tools_dr


   def save_custom_feature_settings(enabled, threshold, last_value):
       """Save custom feature settings to configuration files."""

       # Save to user config (persistent)
       tools_dr.set_config_parser(
           section='custom_feature',
           parameter='enabled',
           value=str(enabled),
           config_type='user',
           file_name='init'
       )

       tools_dr.set_config_parser(
           section='custom_feature',
           parameter='threshold',
           value=str(threshold),
           config_type='user',
           file_name='init'
       )

       # Save to session config (temporary, cleared on restart)
       tools_dr.set_config_parser(
           section='custom_feature',
           parameter='last_value',
           value=str(last_value),
           config_type='user',
           file_name='session'
       )

Code Example - Using Global Variables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Access shared state through ``global_vars``:

.. code-block:: python

   from ... import global_vars


   def get_database_connection():
       """Get the project database connection."""
       # Get GeoPackage data access object
       dao = global_vars.gpkg_dao_data
       if dao is None:
           return None

       # Clone for thread safety in processing algorithms
       return dao.clone()


   def get_project_info():
       """Get current project information."""
       return {
           'project_type': global_vars.project_type,
           'project_epsg': global_vars.project_epsg,
           'data_epsg': global_vars.data_epsg,
           'gpkg_path': global_vars.project_vars.get('project_gpkg_path'),
           'plugin_dir': global_vars.plugin_dir
       }


   def run_feature_with_layer():
       """Example using global iface to get active layer."""
       # Get active layer from QGIS interface
       layer = global_vars.iface.activeLayer()
       if layer is None:
           return

       # Get map canvas
       canvas = global_vars.canvas

       # Access session variables
       threads = global_vars.session_vars.get('threads', [])

Example 4 - Modifying a Database Table
======================================

IberGIS stores its project data in GeoPackage files created from SQL scripts in the ``dbmodel/`` directory. When you change the schema you **must** carefully update both the base DDL/DML and the corresponding ``updates/`` sub-folder if this change is part of a new plugin version.

Scenario
--------

Suppose you want to add a new column ``new_field`` to an existing table ``v_edit_node``.

1. **Update the base DDL** so that new projects include the field.
2. **Update the base DML** if the new field needs default values.
3. **Create an update script** under ``dbmodel/updates/`` so that existing projects can be migrated to the new schema when the plugin is updated.

Step 1 - Modify DDL for New Projects
------------------------------------

The base table definitions are stored in::

   dbmodel/ddl/ddl.sql

Actions:

- Locate the ``CREATE TABLE`` statement for ``v_edit_node``.
- Add the new column definition (type, constraints, default value, etc.).
- Respect the existing style: indentation, type checking using ``CHECK (typeof(...))`` where applicable, and naming conventions.

After this change, **newly created** project GeoPackages will contain the new column.

Code Example - DDL Modification
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In ``dbmodel/ddl/ddl.sql``, locate and modify the table definition:

.. code-block:: sql

   -- Before: existing table definition
   CREATE TABLE v_edit_node (
       node_id TEXT PRIMARY KEY,
       node_type TEXT NOT NULL,
       elevation REAL,
       geom GEOMETRY,
       CHECK (typeof(node_id) = 'text'),
       CHECK (typeof(elevation) = 'real' OR elevation IS NULL)
   );

   -- After: with new column added
   CREATE TABLE v_edit_node (
       node_id TEXT PRIMARY KEY,
       node_type TEXT NOT NULL,
       elevation REAL,
       new_field TEXT DEFAULT 'default_value',
       geom GEOMETRY,
       CHECK (typeof(node_id) = 'text'),
       CHECK (typeof(elevation) = 'real' OR elevation IS NULL),
       CHECK (typeof(new_field) = 'text' OR new_field IS NULL)
   );

Step 2 - Modify DML for Default Data
------------------------------------

Initial data population is defined in::

   dbmodel/dml/dml.sql

If your new column requires a specific default value or must be populated for system tables:

- Extend the corresponding ``INSERT`` statements.
- Or add explicit ``UPDATE`` statements that set appropriate default values for the new column.

Again, follow the existing style and structure of the file.

Code Example - DML Modification
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In ``dbmodel/dml/dml.sql``:

.. code-block:: sql

   -- Option 1: Extend existing INSERT statements
   -- Before:
   INSERT INTO v_edit_node (node_id, node_type, elevation, geom)
   VALUES ('N001', 'junction', 100.5, GeomFromText('POINT(0 0)', 25831));

   -- After: include the new column
   INSERT INTO v_edit_node (node_id, node_type, elevation, new_field, geom)
   VALUES ('N001', 'junction', 100.5, 'initial_value', GeomFromText('POINT(0 0)', 25831));


   -- Option 2: Add UPDATE statement to set defaults for existing records
   UPDATE v_edit_node
   SET new_field = 'default_value'
   WHERE new_field IS NULL;

Step 3 - Add an Update Script for Existing Projects
---------------------------------------------------

Existing projects will not see the new column unless you add an update script under::

   dbmodel/updates/<major>/<minor>/<patch>/

For example, if you are preparing version ``1.2.0``, you might have::

   dbmodel/updates/1/2/0/ddl.sql
   dbmodel/updates/1/2/0/dml.sql
   dbmodel/updates/1/2/0/changelog.txt

Typical actions in the update scripts:

- In **ddl.sql:**

  - Use ``ALTER TABLE`` statements to add the new column to the existing tables.
  - Adjust indexes, triggers or views that depend on the modified table, if needed.

- In **dml.sql:**

  - Initialize the new column for existing records (for example with a default value or a computed value based on existing fields).

- In **changelog.txt:**

  - Document the change (what table/column was added or modified, and why).

Remember that, as explained in :doc:`dbmodel`, **updates must also be reflected in the base files** (``dbmodel/ddl/ddl.sql`` and ``dbmodel/dml/dml.sql``) so that new projects and upgraded projects share the same schema.

Code Example - Update DDL Script
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Create ``dbmodel/updates/1/2/0/ddl.sql``:

.. code-block:: sql

   -- ============================================================
   -- Update script for version 1.2.0
   -- Adds new_field column to v_edit_node table
   -- ============================================================

   -- Add new column to existing table
   ALTER TABLE v_edit_node
   ADD COLUMN new_field TEXT DEFAULT 'default_value';

   -- If there's a view that depends on this table, recreate it
   DROP VIEW IF EXISTS v_node_summary;

   CREATE VIEW v_node_summary AS
   SELECT
       node_id,
       node_type,
       elevation,
       new_field,
       geom
   FROM v_edit_node;

   -- Add index if needed for performance
   CREATE INDEX IF NOT EXISTS idx_v_edit_node_new_field
   ON v_edit_node (new_field);

Code Example - Update DML Script
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Create ``dbmodel/updates/1/2/0/dml.sql``:

.. code-block:: sql

   -- ============================================================
   -- Data migration script for version 1.2.0
   -- Initializes new_field for existing records
   -- ============================================================

   -- Set default value for all existing records
   UPDATE v_edit_node
   SET new_field = 'default_value'
   WHERE new_field IS NULL;

   -- Or set computed values based on existing data
   UPDATE v_edit_node
   SET new_field = CASE
       WHEN node_type = 'junction' THEN 'junction_default'
       WHEN node_type = 'outfall' THEN 'outfall_default'
       ELSE 'other_default'
   END
   WHERE new_field IS NULL;

Code Example - Changelog
^^^^^^^^^^^^^^^^^^^^^^^^

Create ``dbmodel/updates/1/2/0/changelog.txt``:

.. code-block:: text

   Version 1.2.0 - Database Changes
   ================================

   Tables Modified:
   - v_edit_node: Added column 'new_field' (TEXT, default 'default_value')
     Purpose: Stores additional classification data for network nodes.

   Views Modified:
   - v_node_summary: Recreated to include new_field column.

   Indexes Added:
   - idx_v_edit_node_new_field: Index on v_edit_node.new_field for query optimization.

   Migration Notes:
   - Existing records will have new_field set to 'default_value'.
   - No user action required; migration is automatic.

Versioning and Testing
======================

Whenever you introduce schema changes or new Processing algorithms or major UI features:

1. Increment the version in the appropriate place (plugin metadata and ``dbmodel/updates`` folder structure).
2. Create a **new project** with the updated plugin to verify the base DDL and DML.
3. Open an **existing project** and run the update logic to ensure that the ``updates/<major>/<minor>/<patch>`` scripts correctly migrate the database.
4. Run the tests shipped with the plugin, and add new tests when appropriate. Command to run the tests is ``pytest -v``.
5. Document user-visible changes in the changelog files and in the user manual when relevant.
