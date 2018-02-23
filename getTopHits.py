#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Feb 14 11:43:30 2018
Find top hits based on quantile of p-value and subset GWAS results by top 
percentile. P-value needs to have column name "p".
@author: Dan Ju
"""


import pandas as pd
import getopt
import sys
import pdb

def main(argv):
    try:
        opts,args = getopt.getopt(argv, 'o:i:q:', ['output=','input=',
                                                   'quantile='])
    except getopt.GetoptError:
        sys.exit(2)
    for opt,arg in opts:
        if opt in ('-o','--output'):
            export_path = arg
        elif opt in ('-i','--input'):
            import_path = arg
        elif opt in ('-q','--quantile'):
            q = arg
            
    df = pd.read_table(import_path)
    
    quant = df.p.quantile(float(q))
    output_df = df.loc[df.p <= quant, ]
    
    output_df.to_csv(export_path, sep="\t")

if __name__ == '__main__':
    main(sys.argv[1:])