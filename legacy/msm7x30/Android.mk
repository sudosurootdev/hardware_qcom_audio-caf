#AUDIO_POLICY_TEST := true
#ENABLE_AUDIO_DUMP := true

LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
    AudioHardware.cpp \
    audio_hw_hal.cpp

ifeq ($(strip $(QCOM_ANC_HEADSET_ENABLED)),true)
    common_cflags += -DQCOM_ANC_HEADSET_ENABLED
endif
ifeq ($(strip $(QCOM_CSDCLIENT_ENABLED)),true)
    common_cflags += -DQCOM_CSDCLIENT_ENABLED
endif
ifeq ($(strip $(QCOM_FM_ENABLED)),true)
    common_cflags += -DQCOM_FM_ENABLED
endif
ifeq ($(strip $(QCOM_PROXY_DEVICE_ENABLED)),true)
    common_cflags += -DQCOM_PROXY_DEVICE_ENABLED
endif
ifeq ($(strip $(QCOM_OUTPUT_FLAGS_ENABLED)),true)
    common_cflags += -DQCOM_OUTPUT_FLAGS_ENABLED
endif

ifeq ($(BOARD_HAVE_BLUETOOTH),true)
     LOCAL_CFLAGS += -DWITH_A2DP
endif

ifeq ($(QCOM_FM_ENABLED),true)
    LOCAL_CFLAGS += -DQCOM_FM_ENABLED
endif

ifeq ($(BOARD_USES_QCOM_AUDIO_LPA),true)
    LOCAL_CFLAGS += -DQCOM_TUNNEL_LPA_ENABLED
endif

ifeq ($(BOARD_USES_QCOM_AUDIO_SPEECH),true)
    LOCAL_CFLAGS += -DWITH_QCOM_SPEECH
endif

ifeq ($(BOARD_USES_QCOM_AUDIO_VOIPMUTE),true)
    LOCAL_CFLAGS += -DWITH_QCOM_VOIPMUTE
endif

ifeq ($(BOARD_USES_QCOM_AUDIO_RESETALL),true)
    LOCAL_CFLAGS += -DWITH_QCOM_RESETALL
endif

ifeq ($(BOARD_USES_STEREO_HW_SPEAKER),true)
    LOCAL_CFLAGS += -DWITH_STEREO_HW_SPEAKER
endif

ifeq ($(BOARD_HAVE_HTC_AUDIO),true)
    LOCAL_CFLAGS += -DHTC_AUDIO
endif

ifeq ($(BOARD_HAVE_SAMSUNG_AUDIO),true)
    LOCAL_CFLAGS += -DSAMSUNG_AUDIO
endif

ifeq ($(BOARD_HAVE_BACK_MIC_CAMCORDER),true)
    LOCAL_CFLAGS += -DBACK_MIC_CAMCORDER
endif

LOCAL_SHARED_LIBRARIES := \
    libcutils       \
    libutils        \
    libmedia        \
    libaudioalsa

# hack for prebuilt
$(shell mkdir -p $(OUT)/obj/SHARED_LIBRARIES/libaudioalsa_intermediates/)
$(shell touch $(OUT)/obj/SHARED_LIBRARIES/libaudioalsa_intermediates/export_includes)

ifeq ($(BOARD_USES_QCOM_AUDIO_CALIBRATION),true)
    LOCAL_SHARED_LIBRARIES += libaudcal
    LOCAL_CFLAGS += -DWITH_QCOM_CALIBRATION
endif

ifneq ($(TARGET_SIMULATOR),true)
    LOCAL_SHARED_LIBRARIES += libdl
endif

LOCAL_STATIC_LIBRARIES := \
    libmedia_helper \
    libaudiohw_legacy

LOCAL_MODULE := audio.primary.msm7x30
LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw
LOCAL_MODULE_TAGS := optional

LOCAL_CFLAGS += -fno-short-enums

LOCAL_C_INCLUDES := $(TARGET_OUT_HEADERS)/mm-audio/audio-alsa
ifeq ($(BOARD_USES_QCOM_AUDIO_CALIBRATION),true)
    LOCAL_C_INCLUDES += $(TARGET_OUT_HEADERS)/mm-audio/audcal
endif
LOCAL_C_INCLUDES += hardware/libhardware/include
LOCAL_C_INCLUDES += hardware/libhardware_legacy/include
LOCAL_C_INCLUDES += frameworks/base/include
LOCAL_C_INCLUDES += system/core/include

ifneq ($(TARGET_KERNEL_SOURCE),)
    LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include
    LOCAL_ADDITIONAL_DEPENDENCIES := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr
endif

include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)

LOCAL_CFLAGS += $(common_cflags)

LOCAL_SRC_FILES := \
    audio_policy_hal.cpp \
    AudioPolicyManager.cpp

LOCAL_MODULE := audio_policy.msm7x30

LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw
LOCAL_MODULE_TAGS := optional

LOCAL_STATIC_LIBRARIES := \
    libmedia_helper \
    libaudiopolicy_legacy

LOCAL_SHARED_LIBRARIES := \
    libcutils \
    libutils

LOCAL_C_INCLUDES += hardware/libhardware_legacy/audio

include $(BUILD_SHARED_LIBRARY)
