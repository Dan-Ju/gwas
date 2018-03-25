#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar 22 09:14:12 2018
Prune GWAS output files by distance and prioritizes p-value over nearby SNPs. 
Make sure columns specify bp and only does
one chromosome at a time. 
@author: Dan
"""



import pandas as pd
import getopt
import sys

#def main(argv):
#    try:
#        opts,args = getopt.getopt(argv, 'o:i:c:', ['output=','input=',
#                                                   'cutoff='])
#    except getopt.GetoptError:
#        sys.exit(2)
#    for opt,arg in opts:
#        if opt in ('-o','--output'):
#            export_path = arg
#        elif opt in ('-i','--input'):
#            import_path = arg
#        elif opt in ('-c','--cutoff'):
#            cutoff = arg
#            
df = pd.read_table(import_path, header=None)
df = df.sort_values(by=[bp_col])
bp_list = df[2].tolist()
# prune by distance
for i in range(0,len(bp_list)):
    
    

output_df.to_csv(export_path, sep="\t")

#if __name__ == '__main__':
#    main(sys.argv[1:])