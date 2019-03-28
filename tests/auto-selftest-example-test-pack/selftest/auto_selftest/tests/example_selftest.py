#!/usr/bin/python
# coding=utf-8
"""
This file contains regression tests automatically generated by
``stbt auto-selftest``. These tests are intended to capture the
behaviour of Frame Objects (and other helper functions that operate on
a video-frame). Commit this file to git, re-run ``stbt auto-selftest``
whenever you make a change to your Frame Objects, and use ``git diff``
to see how your changes affect the behaviour of the Frame Object.

NOTE: THE OUTPUT OF THE DOCTESTS BELOW IS NOT NECESSARILY "CORRECT" --
it merely documents the behaviour at the time that
``stbt auto-selftest`` was run.
"""
# pylint: disable=line-too-long

import os
import sys

sys.path.insert(0, os.path.join(
    os.path.dirname(__file__), '../../../tests'))

from example import *  # isort:skip pylint: disable=wildcard-import, import-error

_FRAME_CACHE = {}


def f(name):
    img = _FRAME_CACHE.get(name)
    if img is None:
        import cv2
        filename = os.path.join(os.path.dirname(__file__),
                                '../../screenshots', name)
        img = cv2.imread(filename)
        assert img is not None, "Failed to load %s" % filename
        img.flags.writeable = False
        _FRAME_CACHE[name] = img
    return img


def auto_selftest_Dialog():
    r"""
    >>> Dialog(frame=f("frame-object-with-dialog-different-background.png"))
    Dialog(is_visible=True, message=u'This set-top box is great')
    >>> Dialog(frame=f("frame-object-with-dialog.png"))
    Dialog(is_visible=True, message=u'This set-top box is great')
    >>> Dialog(frame=f("frame-object-with-dialog2.png"))
    Dialog(is_visible=True, message=u'This set-top box is fabulous')
    """
    pass


def auto_selftest_FalseyFrameObject():
    r"""
    >>> FalseyFrameObject(frame=f("frame-object-with-dialog-different-background.png"))
    FalseyFrameObject(is_visible=False)
    >>> FalseyFrameObject(frame=f("frame-object-with-dialog.png"))
    FalseyFrameObject(is_visible=False)
    >>> FalseyFrameObject(frame=f("frame-object-with-dialog2.png"))
    FalseyFrameObject(is_visible=False)
    """
    pass


def auto_selftest_TruthyFrameObject2():
    r"""
    >>> TruthyFrameObject2(frame=f("frame-object-without-dialog-different-background.png"))
    TruthyFrameObject2(is_visible=True)
    >>> TruthyFrameObject2(frame=f("frame-object-without-dialog.png"))
    TruthyFrameObject2(is_visible=True)
    """
    pass


def auto_selftest_not_a_frame_object():
    r"""
    >>> not_a_frame_object(4, f("frame-object-with-dialog-different-background.png"))
    hello 4
    True
    >>> not_a_frame_object(4, f("frame-object-with-dialog.png"))
    hello 4
    True
    >>> not_a_frame_object(4, f("frame-object-with-dialog2.png"))
    hello 4
    True
    >>> not_a_frame_object(4, f("frame-object-without-dialog-different-background.png"))
    hello 4
    True
    >>> not_a_frame_object(4, f("frame-object-without-dialog.png"))
    hello 4
    True
    >>> not_a_frame_object(2, f("frame-object-with-dialog-different-background.png"))
    hello 2
    True
    >>> not_a_frame_object(2, f("frame-object-with-dialog.png"))
    hello 2
    True
    >>> not_a_frame_object(2, f("frame-object-with-dialog2.png"))
    hello 2
    True
    >>> not_a_frame_object(2, f("frame-object-without-dialog-different-background.png"))
    hello 2
    True
    >>> not_a_frame_object(2, f("frame-object-without-dialog.png"))
    hello 2
    True
    """
    pass
