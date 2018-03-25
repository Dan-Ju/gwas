#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Mar  6 15:28:32 2018
Find top hits based on quantile of p-value and subset GWAS results by p-value 
cutoff. P-value needs to have column name "p".
@author: Dan
"""


import pandas as pd
import getopt
import sys

def main(argv):
    try:
        opts,args = getopt.getopt(argv, 'o:i:c:', ['output=','input=',
                                                   'cutoff='])
    except getopt.GetoptError:
        sys.exit(2)
    for opt,arg in opts:
        if opt in ('-o','--output'):
            export_path = arg
        elif opt in ('-i','--input'):
            import_path = arg
        elif opt in ('-c','--cutoff'):
            cutoff = arg
            
    df = pd.read_table(import_path)
    
    output_df = df.loc[df.p <= float(cutoff), ]
    
    output_df.to_csv(export_path, sep="\t", index=False)

if __name__ == '__main__':
    main(sys.argv[1:])