Airbnb Market Dynamics of Three European Cities
The datasets come from Inside Airbnb, which provides publicly available listing data for major cities worldwide. They contain 47581 listings for Amsterdam, Porto and Milan, with details on price, location, amenities, availability and host information.
Objectives 
Identify key factors that influence Airbnb listing prices.
Improve model performance using feature engineering.
Explore the role of location — especially distance from city center — in determining price.
Methodology
I combined Python, SQL, and Tableau to conduct this analysis.
Using Python, I cleaned the data, calculated distances from the city center, and created new metrics like occupancy rate, top host and estimated revenue.
I used statistical tests — ANOVA and t-tests — to validate hypotheses and built a predictive model to estimate nightly rates based on property features.
Finally, I visualized the results in Tableau for interactive exploration.
The Python packages used in this project can be found in the requirements file.
Data
The project uses CSV datasets for each city:
- `amsterdam_listings.csv`
- `milan_listings.csv`
- `porto_listings.csv`
Each dataset includes fields like:
- `listing_id`, `name`, `host_id`, `neighbourhood`, `latitude`, `longitude`
- `price`, `minimum_nights`, `number_of_reviews`
- Additional features engineered for the models
Feature Engineering
Features used in modeling include:
Categorical:
room_type
distance_group (binned distance from center)
Continuous:
minimum_nights
availability_365
distance_km
Models
The following models were used to predict Airbnb prices:
- Linear Regression – baseline model with log-transformed prices
- Random Forest Regressor
- Gradient Boosting Regressor
-LightGBM Regressor– tuned for best performance
- Evaluation metrics include MAE, RMSE, and R² score
Use the command to install all dependencies:
```bash
pip install -r requirements.txt
Usage
Clone the repository or download the CSV files.
Load the data into a Jupyter notebook or Python script.
Run preprocessing, feature engineering, and model training scripts.
Evaluate model performance and visualize results.
Author
Teresa Custódio
Data Analyst
Notes
All analyses were conducted using Jupyter Notebook.
Models were tuned and evaluated individually for each city.
Ensure your environment matches the required package versions to reproduce results.
Acknowledgements
I would like to thank Ironhack’s Data Analytics Lead Teacher Frederico Raposo and Teaching Assistant Adi Malik.
License
This project is for educational and research purposes only. Data is sourced from Inside Airbnb, which is licensed under the Creative Commons Attribution 4.0 International License.
Presentation - https://docs.google.com/presentation/d/1jLtUi0s7tdSuvVaILJpKxErHvNUes6V9hK5l4DIZTQY/edit?usp=sharing
Tableau - https://public.tableau.com/views/airbnbvisuals_17581942967520/Story1?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link