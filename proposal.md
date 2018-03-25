# Capstone Proposal

## Project Name

FitCount

## Project Description

FitCount is an iOS and wathcOS app that tracks the user's location and heart rate.  The user is given points when their heart rate goes over a specified threshold.  The points are to be used by gyms as a member reward system.

## Problem statement

Fitness facilities are always looking for ways to reward their members for coming to the gym.  Their members are looking for engaging ways to stay motivated.

## How will your project solve this problem?

FitCount solves this problem by tracking the user's location and heart rate.  FitCount gives the user points for increasing their heart rate when in the gym. 

## Map the user experience

When the user enters their gym they open up FitCount and tap "Start".  Their location is confirmed using the phone's GPS.  The companion watch app then tracks their heart rate until they leave the gym.  While they are in the gym whenever their heart rate goes above a set threshold the user earns points.  These points are then redeemable at their for goods and services.

## What technologies do you plan to use?

* Backend: PostgreSQL, Knex.js, Heroku
* Frontend: Swift
* Libraries: WatchKit, UIKit
