LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := tensorflowlite_jni
LOCAL_SRC_FILES := $(LOCAL_PATH)/../jniLibs/$(TARGET_ARCH_ABI)/libtensorflowlite_jni.so
include $(PREBUILT_SHARED_LIBRARY)