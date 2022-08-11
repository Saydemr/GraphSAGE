#!/bin/bash
organism="$1"

SupModels="gcn graphsage_maxpool graphsage_mean graphsage_meanpool graphsage_seq"
for model in $SupModels
do
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
    
        my_dir="supervised/org${organism}_id_opt${option}"
        mkdir -p ${my_dir}
        python -m graphsage.supervised_train --train_prefix ./example_data/${organism} --model ${model} --base_log_dir ${my_dir} --identity_dim 64 --gpu 0
    
    done
done


# Models="graphsage_maxpool graphsage_meanpool n2v"

# python -m graphsage.utils example_data/${organism}-G.json example_data/${organism}-walks.txt 
# for option in 4 2 1 0 3
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

#     for identity_dim in 32
#     do
#         for lr in 0.0001  
#         do
#             for epoch in 1
#             do
#                 for batch_size in 512
#                 do
#                     for model in $Models
#                     do
#                         my_dir="unsupervised/org${organism}_e${epoch}_b${batch_size}_id${identity_dim}_opt${option}"
#                         mkdir -p ${my_dir}
#                         python -m graphsage.unsupervised_train --train_prefix ./example_data/${organism} --model ${model} --batch_size ${batch_size} --epochs ${epoch} --identity_dim ${identity_dim} --learning_rate ${lr} --validate_iter 100 --print_every 100 --max_total_steps 1000 --base_log_dir ${my_dir} --gpu 0
#                     done
#                 done
#             done
#         done
#     done
# done
