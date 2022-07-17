#!/bin/bash
organism="$1"

SupModels="gcn"
for option in 0
do
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
        cp example_data/${organism}-all_feats.npy example_data/${organism}-feats.npy
    fi

    for epoch in 50 100
    do
        for batch_size in 32 64 128 256 512 1024
        do
            for lr in 0.01 0.001 0.0001 0.1
            do
                for validate_iter in 5 10 50 100 250
                do
                    for validate_batch_size in 256 512 1024
                    do
                        for identity_dim in 32 64 
                        do
                            for model in $SupModels
                            do
                                my_dir="supervised/org${organism}_e${epoch}_b${batch_size}_v${validate_iter}_vb${validate_batch_size}_id${identity_dim}"
                                mkdir -p ${my_dir}
                                python -m graphsage.supervised_train --train_prefix ./example_data/${organism} --model ${model} --batch_size ${batch_size} --epochs ${epoch} --identity_dim ${identity_dim} --learning_rate ${lr} --validate_iter ${validate_iter} --validate_batch_size ${validate_batch_size} --print_every ${validate_iter} --base_log_dir ${my_dir}  --gpu 0
                            done
                        done
                    done
                done
            done
        done
    done
done


# Models="gcn graphsage_maxpool graphsage_mean graphsage_meanpool graphsage_seq n2v"

# for option in 0 1 2 3 4
# do
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
#         cp example_data/${organism}-all_feats.npy example_data/${organism}-feats.npy
#     fi

#     for identity_dim in 32 64 128
#     do
#         for lr in 0.05 0.01 0.005 0.001 0.0001 0.00001
#         do
#             for epoch in 1 3 5
#             do
#                 for model in $Models
#                 do
#                     echo "Identity Dim : ${identity_dim} | Learning Rate : ${lr} | Model : ${model}"
#                     my_dir="unsupervised/id${identity_dim}_lr${lr}_epochs${epoch}"
#                     mkdir -p ${my_dir}
#                     python -m graphsage.unsupervised_train --train_prefix ./example_data/${organism} --model ${model} --batch_size ${batch_size} --epochs ${epoch} --identity_dim ${identity_dim} --learning_rate ${lr} --validate_iter 10 --max_num --base_log_dir ${my_dir} --gpu 0
#                 done
#             done
#         done
#     done
# done
