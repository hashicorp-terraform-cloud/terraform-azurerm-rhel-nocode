#!/bin/bash

# register with rhsm
rhc connect -organization ${var_rhsm_organisation_id} -activation-key ${var_rhsm_activation_key}