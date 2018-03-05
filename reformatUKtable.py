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
        opts,args = getopt.getopt(argv, 'o:m:v:f:', ['output=','main=',
                                                   'variant=','fq='])
    except getopt.GetoptError:
        sys.exit(2)
    for opt,arg in opts:
        if opt in ('-o','--output'):
            export_path = arg
        elif opt in ('-m','--main'):
            m_path = arg
        elif opt in ('-v','--variant'):
            v_path = arg
        elif opt in ('-f','--fq'):
            fq_path = arg

    # Read in data
    df = pd.read_table(m_path)
    fq_df = pd.read_table(fq_path, header=0, names=('Chr','bp','A1','A2','Freq'))
    variant_df = pd.read_table(v_path, header=0, names=('Chr','bp','Ref','Alt'))
    # Create empty data frame 
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
    
    # Sort both data frames
    sorted_out = output_df.sort_values(by=['Chr','bp'])
    sorted_out = sorted_out.reset_index(drop=True)
    sorted_fq = fq_df.sort_values(by=['Chr','bp'])
    sorted_fq = sorted_fq.reset_index(drop=True)
    
    sorted_out['A1'] = sorted_fq['A1']
    sorted_out['A2'] = sorted_fq['A2']
    sorted_out['Freq'] = sorted_fq['Freq']
    
    sorted_out.to_csv(export_path, sep="\t", index=False)

if __name__ == '__main__':
    main(sys.argv[1:])