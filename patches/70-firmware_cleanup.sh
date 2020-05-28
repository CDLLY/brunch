# Cleanup chromebooks specific config files / firmares as they might break things

ret=0

if [ -d /system/etc/bluetooth ]; then
	rm -r /system/etc/bluetooth/*
	if [ ! "$?" -eq 0 ]; then ret=$((ret + (2 ** 0))); fi
fi

if [ -d /system/etc/cras ]; then
	rm -r /system/etc/cras/*
	if [ ! "$?" -eq 0 ]; then ret=$((ret + (2 ** 1))); fi
fi

if [ -d /system/etc/dptf ]; then
	rm -r /system/etc/dptf/*
	if [ ! "$?" -eq 0 ]; then ret=$((ret + (2 ** 2))); fi
fi

exit $ret