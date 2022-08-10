#!/bin/bash
organism="$1"

# SupModels="graphsage_maxpool graphsage_meanpool"
# for option in 0 1 2 3 4
# do
#     rm -f example_data/${organism}-feats.npy
#     if [ $option -eq 1 ]; then 
#         cp example_data/${organism}-sl_feats.npy example_data/${organism}-feats.npy
#     fi
#     if [ $option -eq 2 ]; then 
#         cp example_data/${organism}-ge_feats.npy example_data/${organism}-feats.npy
#     fi
#     if [ $option -eq 3 ]; then 
#         cp example_data/${organism}-go_feats.npy example_data/${organism}-feats.npy
#     fi
#     if [ $option -eq 4 ]; then 
#         cp example_data/${organism}-all-feats.npy example_data/${organism}-feats.npy
#     fi

#     for epoch in 50
#     do
#         for batch_size in 32
#         do
#             for lr in 0.01 0.001 0.0001
#             do
#                 for validate_iter in 100
#                 do
#                     for validate_batch_size in 512
#                     do
#                         for identity_dim in 32
#                         do
#                             for model in $SupModels
#                             do
#                                 my_dir="supervised/org${organism}_e${epoch}_b${batch_size}_v${validate_iter}_vb${validate_batch_size}_id${identity_dim}_opt${option}"
#                                 mkdir -p ${my_dir}
#                                 python -m graphsage.supervised_train --train_prefix ./example_data/${organism} --model ${model} --batch_size ${batch_size} --epochs ${epoch} --identity_dim ${identity_dim} --learning_rate ${lr} --validate_iter ${validate_iter} --validate_batch_size ${validate_batch_size} --print_every 10000 --base_log_dir ${my_dir}  --gpu 0
#                             done
#                         done
#                     done
#                 done
#             done
#         done
#     done
# done


Models="graphsage_maxpool graphsage_meanpool n2v"

python -m graphsage.utils example_data/${organism}-G.json example_data/${organism}-walks.txt 
for option in 0 1 2 3 4
do
    rm -f example_data/${organism}-feats.npy 
    if [ $option -eq 1 ]; then 
        cp example_data/${organism}-sl_feats.npy example_data/${organism}-feats.npy
    fi
    if [ $option -eq 2 ]; then 
        cp example_data/${organism}-ge_feats.npy example_data/${organism}-feats.npy
    fi
    if [ $option -eq 3 ]; then 
        cp example_data/${organism}-go_feats.npy example_data/${organism}-feats.npy
    fi
    if [ $option -eq 4 ]; then 
        cp example_data/${organism}-all-feats.npy example_data/${organism}-feats.npy
    fi

    for identity_dim in 32
    do
        for lr in 0.0001  
        do
            for epoch in 1
            do
                for batch_size in 512
                do
                    for model in $Models
                    do
                        my_dir="unsupervised/org${organism}_e${epoch}_b${batch_size}_id${identity_dim}_opt${option}"
                        mkdir -p ${my_dir}
                        python -m graphsage.unsupervised_train --train_prefix ./example_data/${organism} --model ${model} --batch_size ${batch_size} --epochs ${epoch} --identity_dim ${identity_dim} --learning_rate ${lr} --validate_iter 100 --print_every 1000 --max_total_steps 10000 --base_log_dir ${my_dir} --gpu 0
                    done
                done
            done
        done
    done
done
