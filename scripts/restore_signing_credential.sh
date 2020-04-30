#!/bin/bash -ex
echo -n $ENTERPRISE_P12_ENC | base64 --decode > $ENTERPRISE_P12_FILE
echo -n $PROFILE_EXAMPLE_OBJC_APP_ENC | base64 --decode > $PROFILE_EXAMPLE_OBJC_APP_FILE
