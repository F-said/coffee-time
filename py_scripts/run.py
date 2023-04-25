import extract_pdfs

import transform_bean
import transform_tree
import transform_et

import join

def main():
    # extract data
    extract_pdfs.main()

    # transform and create new data
    transform_bean.main()
    transform_tree.main()
    transform_et.main()

    # join together
    join.main()

    # save to db

if __name__=="__main__":
    main()
