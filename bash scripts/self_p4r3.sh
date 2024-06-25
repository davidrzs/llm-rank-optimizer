#!/bin/bash

product=4
run=3
python rank_opt.py \
    --results_dir results/self/product${product}/run${run} \
    --target_product_idx $product \
    --num_iter 2000 --test_iter 50 \
    --random_order \
    --mode self