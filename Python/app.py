import streamlit as st
import pandas as pd
import joblib

# Load the trained model
model = joblib.load("Risk_model1.pkl")

st.title("Healthcare Risk Stratification App")

# User inputs
age = st.number_input("Age", min_value=0)
length_of_stay = st.number_input("Length of Stay (days)", min_value=0)
treatment_cost = st.number_input("Treatment Cost", min_value=0.0)

if st.button("Predict"):

    input_data = pd.DataFrame(
        [[age, length_of_stay, treatment_cost]],
        columns=["Age", "LengthOfstay", "TreatmentCost"]   
    )

    prediction = model.predict(input_data)[0]
    probability = model.predict_proba(input_data)[0][1]

    if prediction == 1:
        st.success("Risk Prediction: High Risk")
    else:
        st.success("Risk Prediction: Low Risk")

    st.write(f"Risk Probability: {probability:.2f}")




