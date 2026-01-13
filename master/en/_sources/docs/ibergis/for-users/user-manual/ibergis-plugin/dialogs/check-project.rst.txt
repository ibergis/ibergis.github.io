.. _dialog-check-project:

====================
Dialog Check project
====================

.. only:: html

    .. contents::
       :local:


.. figure:: img/check-project-tool.png

    Check project.

It allows to verify that all elements of the simulation are complete and error-free.

This tool has a checkbox to display only the warnings and errors.

Clicking in *Accept* button will start the check.

Error Management
================

The errors can be displayed in two ways:
    - **Log message:** shows an error message on the *Database log* panel.
    - **Load an error layer:** loads an error layer with the incorrect objects and errors as fields to display the problematic objects on the map.

.. note:: All errors are reported as log messages, but there are some errors that create a layer with the problematic objects.

There are three types of messages on the *Database log* panel:
    - **Info:** the check is completed successfully.
    - **Warning:** the check found errors that do not break the simulation.
    - **Error:** the check found errors that most likely will break the simulation.