#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Feb 23 13:25:47 2018

@author: Dan Ju
"""
# Reformats UK biobank GWAS results table for further analysis

import pandas as pd
import getopt
import sys
import numpy as np

def main(argv):
    try:
        opts,args = getopt.getopt(argv, 'o:m:v:', ['output=','main=',
                                                   'variant='])
    except getopt.GetoptError:
        sys.exit(2)
    for opt,arg in opts:
        if opt in ('-o','--output'):
            export_path = arg
        elif opt in ('-m','--main'):
            m_path = arg
        elif opt in ('-v','--variant'):
            v_path = arg
            
    df = pd.read_table(m_path)
    variant_df = pd.read_table(v_path, header=0, names=('Chr','bp','Ref','Alt'))
    
    output_df = pd.DataFrame(np.nan, index=range(0,len(df)), 
                             columns=['Chr','SNP','bp','A1','A2','Freq','b',
                                      'se','p'])
    
    output_df['Chr'] = variant_df['Chr']
    output_df['bp'] = variant_df['bp']
    output_df['SNP'] = output_df['Chr'].astype(str) + ":" + \
                        output_df['bp'].astype(str)
    output_df['b'] = df['beta']
    output_df['p'] = df.iloc[:,8]
    output_df['se'] = df['se']
    
    output_df.to_csv(export_path, sep="\t", index=False)

if __name__ == '__main__':
    main(sys.argv[1:])