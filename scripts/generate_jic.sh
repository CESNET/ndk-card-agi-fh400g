#!/bin/bash
#
# Copyright (C) 2022 CESNET z. s. p. o.
# Author(s): Jakub Cabal <cabal@cesnet.cz>
#
# SPDX-License-Identifier: BSD-3-Clause

if [ $# != 1 ] ; then
    echo "Usage:"
    echo "------"
    echo "    sh generate_jic.sh <input sof file>"
    echo " "
    echo "Example:"
    echo "    sh generate_jic.sh my_firmware.sof"
    exit
fi

my_folder=$(pwd)
file=$1
filename=${file%.*}
extension=${file##*.}

if [ $extension != "sof" ] ; then
    echo "Usage:"
    echo "------"
    echo "    sh generate_jic.sh <input sof file>"
    exit
fi

if [ $extension == "sof" ] ; then
    touch ${filename}".pfg"
    echo "<pfg version=\"1\">
    <settings custom_db_dir=\"$my_folder/\" mode=\"ASX4\"/>
    <output_files>
        <output_file name=\"$filename\" directory=\".\" type=\"JIC\">
            <file_options/>
            <secondary_file type=\"MAP\" name=\"$filename\">
                <file_options/>
            </secondary_file>
            <flash_device_id>Flash_Device_1</flash_device_id>
        </output_file>
    </output_files>
    <bitstreams>
        <bitstream id=\"Bitstream_1\">
            <path>$file</path>
        </bitstream>
    </bitstreams>
    <flash_devices>
        <flash_device type=\"MT25QU01G\" id=\"Flash_Device_1\">
            <partition reserved=\"1\" fixed_s_addr=\"1\" s_addr=\"0x00000000\" e_addr=\"0x001FFFFF\" fixed_e_addr=\"1\" id=\"BOOT_INFO\" size=\"0\"/>
            <partition reserved=\"0\" fixed_s_addr=\"0\" s_addr=\"auto\" e_addr=\"auto\" fixed_e_addr=\"0\" id=\"P1\" size=\"0\"/>
        </flash_device>
        <flash_loader>AGIB027R29AR0</flash_loader>
    </flash_devices>
    <assignments>
        <assignment page=\"0\" partition_id=\"P1\">
            <bitstream_id>Bitstream_1</bitstream_id>
        </assignment>
    </assignments>
    </pfg>" > ${filename}".pfg"

    echo "Converting to JIC File."
    quartus_pfg -c ${filename}.pfg
    rm ${filename}.pfg
    echo "JIC file generated successfully!"
fi
