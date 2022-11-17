import os, re
from collections import defaultdict

spell_dic=defaultdict(lambda: "")
supported_spells = list()
present_spells = list()

def load_spell_names():
	with open('spellNames/en_US.txt', 'r') as f:
		for line in f.readlines():
			if re.search(r'\w*;(\w*)+', line) is not None:
				id, name = line.strip().split(";")
				spell_dic[id]=name


def load_supported_spell_ids():
	with open('SpellList.lua', 'r') as f:
		for line in f.readlines():
			m = re.search(r"\[(\d+)\].*\=", line)
			if m and m.group(1):
				supported_spells.append(m.group(1))
	supported_spells.append('taunted')
	supported_spells.append('countered')


def load_existing_spells():
	for root, dirs, files in os.walk('VRA_EN_Julie/sounds'):
		for file in files:
			filename = os.path.basename(file)
			present_spells.append(os.path.splitext(filename)[0])


def check_julie_soundpack():
	load_spell_names()
	load_supported_spell_ids()
	load_existing_spells()
	missing_spells = list(set(supported_spells) - set(present_spells))

	if (len(missing_spells)):
		for id in missing_spells:
			print(f"{id}-{spell_dic[id]}")

check_julie_soundpack()


