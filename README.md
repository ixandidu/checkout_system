# Checkout System

The task is to implement a checkout system that conforms to the following
interface:

    co = Checkout.new(rules)
    co.scan(item)
    co.scan(item)
    price = co.total

## Items

 Item | Price
------|-------
  A   | £30
  B   | £20
  C   | £50
  D   | £15

## Promotions

* If 3 of item A are purchased, the price for all 3 is £75.
* If 2 of item B are purchased, the price for both is £35.
* If the total basket price (after previous discounts) is over £150, the basket
  receives a discount of £20.

## Example Test Data

 Basket                 | Price
------------------------|-------
  A, B, C               | £100
  B, A, B, A, A         | £110
  C, B, A, A, D, A, B   | £155
  C, A, D, A, A         | £140

## Basic Requirements

The exercise shouldn't take more than a couple of hours, but fell free to spend
as much or as little time on it as long as you do the following:

* Implement the interface above in ruby
* Write tests, which can be easily ran in one step
* Include you git history and commit regularly so we can see your thought
  process
* Cater for the design considerations below

## Design Considerations

We expect the marketing team will want to invent **new types** of promotional
rules beyond the current multi-buy and basket total promotions. The design
should allow the system to extended in a way that follows
[SOLID](https://en.wikipedia.org/wiki/SOLID) principles.
