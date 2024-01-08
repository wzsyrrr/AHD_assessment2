rule visualization:
    input: "clean/clean_dt.csv"
    shell: """
        rscript visualisation/bmi_app.R
        """

rule clean:
    input: 
        "raw/BMI.csv",
        "raw/DEMO_D.csv",
        "raw/FFQRAW_D.csv"
    output: "clean/clean_dt.csv"
    shell: """
        mkdir -p clean
        rscript code/data_clean.R
        """

