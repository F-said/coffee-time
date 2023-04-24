import extract_pdfs

import transform_bean
import transform_tree

import join_bean

def main():
    # extract data
    extract_pdfs.main()

    # transform and create new data
    transform_bean.main()
    transform_tree.main()
    # join together
    join_bean.main()

    # save to db

if __name__=="__main__":
    main()
