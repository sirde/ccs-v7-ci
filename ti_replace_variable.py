import argparse
import xml.etree.ElementTree as ET

import os

parser = argparse.ArgumentParser()
parser.add_argument('project_path', help='foo help', default='/workdir/setza_fw_noos')
args = parser.parse_args()

with open(os.path.join(args.project_path, '.project'), encoding='UTF-8') as f:
    tree = ET.parse(f)
    root = tree.getroot()

    for child in root.getiterator():
        # print(child.tag, child.attrib)
        if child.tag == 'value' and child.text == 'file:/C:/ti/CC3200SDK_1.3.0/cc3200-sdk':
            child.text = 'file:/opt/ti/CC3200SDK_1.3.0/cc3200-sdk'

    tree.write(os.path.join(args.project_path, '.project'),  encoding='utf8', method='xml')
